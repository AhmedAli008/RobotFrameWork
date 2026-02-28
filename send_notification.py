import smtplib
import os
import sys
import xml.etree.ElementTree as ET
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
from glob import glob


def parse_robot_output():
    """Parse Robot Framework output.xml to extract test results."""
    output_files = glob("Output/output*.xml")
    if not output_files:
        return None

    # Use the most recent output file
    output_file = sorted(output_files)[-1]

    try:
        tree = ET.parse(output_file)
        root = tree.getroot()

        stat = root.find(".//statistics/total/stat")
        if stat is not None:
            total = int(stat.get("pass", 0)) + int(stat.get("fail", 0))
            passed = int(stat.get("pass", 0))
            failed = int(stat.get("fail", 0))
            skipped = int(stat.get("skip", 0))
        else:
            total = passed = failed = skipped = 0

        # Collect failed test names
        failed_tests = []
        for test in root.iter("test"):
            status = test.find("status")
            if status is not None and status.get("status") == "FAIL":
                failed_tests.append({
                    "name": test.get("name"),
                    "message": status.text or "No message"
                })

        return {
            "total": total,
            "passed": passed,
            "failed": failed,
            "skipped": skipped,
            "failed_tests": failed_tests,
            "output_file": output_file
        }
    except Exception as e:
        print(f"Error parsing output: {e}")
        return None


def build_email_html(results, trigger_source, dev_branch, dev_commit, release_tag, env, pipeline_url):
    """Build HTML email body with test results."""
    if results is None:
        status_color = "#e74c3c"
        status_text = "ERROR - No Results"
    elif results["failed"] == 0:
        status_color = "#27ae60"
        status_text = "ALL TESTS PASSED"
    else:
        status_color = "#e74c3c"
        status_text = f"{results['failed']} TEST(S) FAILED"

    failed_tests_html = ""
    if results and results["failed_tests"]:
        rows = ""
        for i, test in enumerate(results["failed_tests"], 1):
            rows += f"""
            <tr>
                <td style="padding: 8px; border: 1px solid #ddd;">{i}</td>
                <td style="padding: 8px; border: 1px solid #ddd;">{test['name']}</td>
                <td style="padding: 8px; border: 1px solid #ddd; color: #e74c3c;">{test['message'][:200]}</td>
            </tr>"""

        failed_tests_html = f"""
        <h3 style="color: #e74c3c;">Failed Tests</h3>
        <table style="border-collapse: collapse; width: 100%;">
            <tr style="background-color: #f8f9fa;">
                <th style="padding: 8px; border: 1px solid #ddd;">#</th>
                <th style="padding: 8px; border: 1px solid #ddd;">Test Name</th>
                <th style="padding: 8px; border: 1px solid #ddd;">Error Message</th>
            </tr>
            {rows}
        </table>"""

    total = results["total"] if results else 0
    passed = results["passed"] if results else 0
    failed = results["failed"] if results else 0
    skipped = results["skipped"] if results else 0

    html = f"""
    <html>
    <body style="font-family: Arial, sans-serif; margin: 0; padding: 20px; background-color: #f5f5f5;">
        <div style="max-width: 700px; margin: 0 auto; background-color: #ffffff; border-radius: 8px; overflow: hidden; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">

            <!-- Header -->
            <div style="background-color: {status_color}; color: white; padding: 20px; text-align: center;">
                <h1 style="margin: 0; font-size: 22px;">Robot Framework Test Results</h1>
                <p style="margin: 5px 0 0; font-size: 18px; font-weight: bold;">{status_text}</p>
            </div>

            <!-- Trigger Info -->
            <div style="padding: 20px; border-bottom: 1px solid #eee;">
                <h3 style="margin-top: 0; color: #333;">Trigger Information</h3>
                <table style="width: 100%;">
                    <tr><td style="padding: 4px 8px; color: #666;">Trigger Source:</td><td style="padding: 4px 8px;"><strong>{trigger_source}</strong></td></tr>
                    <tr><td style="padding: 4px 8px; color: #666;">Dev Branch:</td><td style="padding: 4px 8px;"><strong>{dev_branch}</strong></td></tr>
                    <tr><td style="padding: 4px 8px; color: #666;">Dev Commit:</td><td style="padding: 4px 8px;"><code>{dev_commit[:8] if len(dev_commit) > 8 else dev_commit}</code></td></tr>
                    {"<tr><td style='padding: 4px 8px; color: #666;'>Release Tag:</td><td style='padding: 4px 8px;'><strong>" + release_tag + "</strong></td></tr>" if release_tag != "N/A" else ""}
                    <tr><td style="padding: 4px 8px; color: #666;">Environment:</td><td style="padding: 4px 8px;"><strong>{env}</strong></td></tr>
                </table>
            </div>

            <!-- Results Summary -->
            <div style="padding: 20px; border-bottom: 1px solid #eee;">
                <h3 style="margin-top: 0; color: #333;">Test Results Summary</h3>
                <table style="width: 100%; text-align: center;">
                    <tr>
                        <td style="padding: 15px;">
                            <div style="font-size: 32px; font-weight: bold; color: #333;">{total}</div>
                            <div style="color: #666;">Total</div>
                        </td>
                        <td style="padding: 15px;">
                            <div style="font-size: 32px; font-weight: bold; color: #27ae60;">{passed}</div>
                            <div style="color: #666;">Passed</div>
                        </td>
                        <td style="padding: 15px;">
                            <div style="font-size: 32px; font-weight: bold; color: #e74c3c;">{failed}</div>
                            <div style="color: #666;">Failed</div>
                        </td>
                        <td style="padding: 15px;">
                            <div style="font-size: 32px; font-weight: bold; color: #f39c12;">{skipped}</div>
                            <div style="color: #666;">Skipped</div>
                        </td>
                    </tr>
                </table>
            </div>

            <!-- Failed Tests Details -->
            {failed_tests_html if failed_tests_html else ""}

            <!-- Pipeline Link -->
            <div style="padding: 20px; text-align: center;">
                <a href="{pipeline_url}" style="display: inline-block; padding: 10px 25px; background-color: #0052CC; color: white; text-decoration: none; border-radius: 4px;">View Pipeline Details</a>
            </div>

            <!-- Footer -->
            <div style="padding: 15px; background-color: #f8f9fa; text-align: center; color: #999; font-size: 12px;">
                Automated notification from Origin Systems - Robot Framework Automation
            </div>
        </div>
    </body>
    </html>
    """
    return html


def send_email(html_body, status_text):
    """Send email notification via SMTP."""
    smtp_server = os.environ.get("SMTP_SERVER", "smtp.sendgrid.net")
    smtp_port = int(os.environ.get("SMTP_PORT", "587"))
    smtp_user = os.environ.get("SMTP_USER", "apikey")
    smtp_password = os.environ.get("SMTP_PASSWORD", "")
    sender_email = "Ahmed.Ali@originsysglobal.com"
    recipient = "Ahmed.Ali@originsysglobal.com"

    if not smtp_user or not smtp_password:
        print("WARNING: SMTP_USER and SMTP_PASSWORD not set. Skipping email notification.")
        print("Add these as secured repository variables in Bitbucket Pipeline settings.")
        return False

    msg = MIMEMultipart("alternative")
    msg["Subject"] = f"[Automation] {status_text} - Robot Framework Tests"
    msg["From"] = sender_email
    msg["To"] = recipient

    msg.attach(MIMEText(html_body, "html"))

    try:
        server = smtplib.SMTP(smtp_server, smtp_port)
        server.starttls()
        server.login(smtp_user, smtp_password)
        server.sendmail(sender_email, [recipient], msg.as_string())
        server.quit()
        print(f"Email notification sent to {recipient}")
        return True
    except Exception as e:
        print(f"Failed to send email: {e}")
        return False


def main():
    trigger_source = os.environ.get("TRIGGER_SOURCE", "manual")
    dev_branch = os.environ.get("DEV_BRANCH", "unknown")
    dev_commit = os.environ.get("DEV_COMMIT", "unknown")
    release_tag = os.environ.get("RELEASE_TAG", "N/A")
    env = os.environ.get("ENV", "test")
    pipeline_url = os.environ.get(
        "BITBUCKET_PIPELINE_URL",
        f"https://bitbucket.org/{os.environ.get('BITBUCKET_WORKSPACE', '')}/{os.environ.get('BITBUCKET_REPO_SLUG', '')}/pipelines"
    )

    # Parse test results
    results = parse_robot_output()

    if results:
        if results["failed"] == 0:
            status_text = f"PASSED ({results['passed']}/{results['total']})"
        else:
            status_text = f"FAILED ({results['failed']}/{results['total']} failed)"
    else:
        status_text = "ERROR - No test results found"

    print(f"\nTest Status: {status_text}")

    # Build and send email
    html_body = build_email_html(results, trigger_source, dev_branch, dev_commit, release_tag, env, pipeline_url)
    send_email(html_body, status_text)


if __name__ == "__main__":
    main()
