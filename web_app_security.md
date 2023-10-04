## OWASP Top 10

- OWASP: Open Worldwide Application Security Project (OWASP) is a nonprofit foundation that works to improve the security of software.
- 2021 is the latest list
- Top 10
	1. Broken Access Control / Permissions
	2. Cryptographic Failures
	3. Injection
	4. Insecure Design
	5. Security Misconfiguration
	6. Vulnerable and Outdated Components
	7. ID and Authentication Failures
	8. Software and Data Integration Failures
	9. Security and Monitoring Failures
	10. Server-Side Request Forgery (SSRF)

## OWASP Top 10 SORTED By Average Incident Rate

- 8.77% Vulnerable and Outdated Components
- 6.51% Security and Monitoring Failures
- 4.91% Cryptographic Failures
- 4.51% Security Misconfiguration
- 3.81% Broken Access Control / Permissions
- 3.37% Injection
- 3.00% Insecure Design
- 2.82% Server-Side Request Forgery (SSRF)
- 2.55% ID and Authentication Failures
- 2.05% Software and Data Integration Failures

## OWASP Top 10 Recommendations

- OWASP: Open Worldwide Application Security Project (OWASP) is a nonprofit foundation that works to improve the security of software.
- 2021 is the latest list
- Top 10
1. Broken Access Control / Permissions
	- Set permissions for DB, APP (process) and OS according to LEAST PRIVILEGE
	- Prefer Allow lists over Deny lists (b/c of alternate character encoding)
	- Don't expose data using direct object references: (user_id=1,2,..)
2. Cryptographic Failures
	- Avoid storing sensitive data if you can (like payment info)
	- Encrypt sensitive data if you must store it.
	- Encrypt ALL DATA in transit.
	- Always use authenticated encryption instead of just encryption. KJ ???
	- Use mappings or tokens, not direct references (user_id: 1,2,3,... is insecure)
	- Prefer tokenization over encryption / decryption
	- Data in motion can be encrypted in transport (TLS) and in message (payload) for critical data, or data where there are intermediates.
3. Injection
	- Validate all untrusted data, All JS app data is untrusted data!
	- Validate text in every way possible
		- syntax: min/max length, legal characters, nulls?, duplicates allowed?, valid regex?, type
		- semantically: sensible answers within context
	- Question - where in your program will a 2MB username get validated?
	- Stored Procedures, HTML input, etc should be parameterized. Don't concatenate user input.
	- Prefer an API, which by design, parameterizes inputs.
	- Avoid using EXEC, EVAL, or DYNAMIC user entry.
4. Insecure Design
	- Bake security into the design process.
	- Develop an app security lifecycle.
	- Design security starting from your most valuable assets, and move outward toward the UI.
	- Use threat modeling for authentication, access control, and key logic.
	- Don't just rely on code scanners, or other tools after you write code (too late)
	- NSA recommends moving toward memory safe languages (such as C#, Go, Java, Ruby, Rust, and Swift).  This will eliminate 70% of security breaches!
5. Security Misconfiguration
	- Check for default users and passwords.
	- Disable directory listing.
	- Do not provide detailed error messages to the user. Customize your error screens with the least possible information.
	- Disable, or remove all unused components.
	- Don't use default users, default passwords, or default locations
	- Log files should be highly restricted.
	- Protect SECRETS & do not push them to Github! Use environment variables.
	- Passwords should be hashed and SALTED (a random string added to the password, stored in the db; this prevents password table attacks)
	- On logout, and abandoned sessions, apps should clear sessions and assign cookies a NULL value.
6. Vulnerable and Outdated Components
	- Keep software components up to date
7. ID and Authentication Failures
	- Limit or delay multiple login attemps
	- Set session timeouts appropriately (Example 2-5 minutes for high value, up to 30 min for low value)
	- Limit number of sessions per user.
	- Prevent automated login attacks - preferably using MFA.
	- Disallow weak passwords, such as those from the 10,000 most common list (123456, password, etc.)
	- Passwords should be strongly hashed
	- Do not expose the session id in the URL.
	- Recommend password managers to users.
	- Frequent password rotation, and password complexity requirements are disfavored now; prefer MFA
8. Software and Data Integration Failures
	- Never put source code on the server
	- Use checksums, or other digital signatures
9. Security and Monitoring Failures
	- Log logins, failed logins, and high value transactions.
	- Logs should NOT reveal secrets
	- Log warnings, and errors
	- Public error messages should NOT reveal the tools
	- All deserialized data (JSON, XML, etc) should be untrusted and validated
	- Don't serialize exploitable state. Ex: Does your user state include an admin role?
10. Server-Side Request Forgery (SSRF)
	- This is when a user supplied URL is used to probe normally protected internal servers (ex: an image photo url would normally be an external server, but can be used instead to scan the internal servers)
	- Sanitize & validate user URLs.
	- Use allow lists for URLs.
	- Do not accept file://, localhost, and all non-http protocols.

## Resources

- Good podcast: https://www.grc.com/securitynow.htm  Also has notes for reading.
- Common Vulnerabilities and Exposures (CVE) https://cve.mitre.org/cve/
- https://public.cyber.mil/stigs/downloads/?_dl_facet_stigs=app-security DOD
- https://wiki.sei.cmu.edu/confluence/display/seccode/Top+10+Secure+Coding+Practices  CARNEGIE MELON WEB SEC LIST
- Crypto General: https://csrc.nist.gov/Projects/cryptographic-standards-and-guidelines
- Crypto Key Length: https://www.keylength.com/
- Crypto Key Management: https://nvlpubs.nist.gov/nistpubs/specialpublications/nist.sp.800-57pt1r4.pdf
- Web Application Security Consortium: http://www.webappsec.org/

## General Principals

- Obscurity is not a good security measure (though it can be used in conjuection with other methods)
- Security is about MITIGATION. They make you SAF-ER, but not SAFE. Just try to keep moving toward safer.
- Default to a secure position.  Deviate as is appropriate. Example: does a refrigerator need security? It depends1. $10,000 wine.  Yes.  Beer with a teenagers in the house.  Probably, etc.

## Terminology

- Allow / Deny List:  more modern terms for Whitelist/ Blacklist.
- CVE: Common vulnerabilities and Exploits - MITRE/CISA
- CSRF: Cross Site Request Forgery.  A link or form which simply guesses that you have an open session (tab) that it can use against you. Ex: You have a tab open with your bank, and you click on a social media link, which transfers money from you! CSRF tokens are sent from the server to ensure subsequent requests are from you.
- CWE: Common Weakness Enumeration
- Forced / forceful Browsing: Where an attacker knows, infers, or guesses target URLS.
- HTTP Endpoint: broader term for browser, anything that can generate HTML requests
- KEV: Known Exploited Vulnerabilities Catalog - CISA
- Malware: any malicious software, but often used in ransoming
- NVD: National Vulnerability Database - NIST
- RCE Attack: the ability for ran attacker to execute code remotely
- SBOM: Software Bill of Materialsis a nested inventory, a list of software components, to help ID possible vulnerabilities (Ex: Do we use log4j?)
- SDL - Software Development Lifecycle
- SSRF - Server-Side Request Forgery:  when a user supplied URL is used to probe normally protected internal servers (ex: an image photo url would normally be an external server, but can be used instead to scan the internal servers. Or a malicious redirect URL may be provided by an attacker.
- STIG: Security and Technical Implementation Guide
- Supply Chain Attack: any malware directed at suppliers of software (example Solar Winds)
- System Hardening:	To reduce security, typically by removing all non-essential programs and utilities (reduce backdoors)	
- Trusted data: data validated within a safe context
- Web Shell: any persistent connection to malware, aka backdoor, often written in PHP (a common server language)
- XSS: Cross Site Scripting Attack.  Initially indicating, attack in which data was taken from one website to another, the term typically indicates client side code (usually JS) which targets the users of a site rather than the site itself.  For example - a script tag may send user data to the attacker's site.
- Zero Day Exploit: an attack that occurs on the same day it is discovered

## Misconceptions

- I'm safe because we have a firewall. Firewalls are only concerned with the IP and port.
- I'm safe because I use SSL. SSL is OLD! TSL replaced it. Encryption stops and starts at the two endpoints.  UNTRUSTED data simply gets encrypted and unencrypted when it gets to the server.
- I'm safe because I have React app.  ALL JS APPS, THIS MEANS REACT, ANGULAR, etc. PROVIDE UNTRUSTED DATA. JS CAN EASILY BE REVERSE ENGINEERED!
- TSL encrypts the URL. No - it's in plain text, needed for the routing.
- There's a set limit to HTTP POST. No it's UNDEFINED! It's typically 2MB or 8MB depending on the configuration.
- I'm safe because I'm using security through obscruity (STO). No, sites get indexed and eventually discovered.

## SECURITY RESEARCH

- Do not conduct security research without prior approval!  All black hats
claim they are white hats! Always ask for and understand your company's security policies.
- Software: DO NOT INSTALL THIS SOFTWARE ON WORK COMPUTERS WITHOUT AUTHORIZATION - YOU WILL HAVE ISSUES
	- AppSpider
	- Burp Proxy
	- Firefox Web Developer
	- Fortify WebInspect
	- Foundstone's SASS Hacme Tools
	- Google Hacking Database
	- OWASP Zed Attack Proxy ZAP Project
	- SQL Power Injector
	- WebGoat
- Types of Security Software
	- Application Firewalls
	- Static Scanners
	- Dynamic Scanners
-- Google Dorks
	- A set of advanced search syntax for researching websites
	- Example: Google Search: "site:triveratech.com filetype:pdf"
- Application Firewalls
	- Not IP Firewalls
	- Actually look at the data
	- IP firewalls do not look at the data!
	- Can actually examine expected data for a field
- Tools
	- Telerik Fiddler: Windows version of Postman
	- Postman
	- Wireshark

## Real World Examples

- The credit rating company, Experian, exposed 143M customer's data because, because the Apache Struts deserialization header allowed for Java remote code execution.
- Verizon relied on security through obscurity for an internal website. A researcher discovered the website and accessed 2M contracts, which were listed in sequential order (Direct Object Reference)
- Heartland, a financial services company, exposed 130M credit cards numbers because an HTML field allowed SQL injection.
