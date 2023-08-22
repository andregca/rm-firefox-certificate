# Certificate Removal Script

Sometimes you use RFC1918 private ip addresses for internal applications, with self signed certificates, and, there is a chance of having different applications, running on different VPNs, that choose to use the same CN on self-signed certificates.

In that case, there is a need to remove the existing entries on cert db and cert_override.txt file, to let firefox work with these sites. If you don't do that, you will receive the error "sec_error_reused_issuer_and_serial" and won't be able to access the site.

This script is designed to remove certificate entries from the `cert9.db` file and `cert_override.txt` file used by Mozilla Firefox. It allows you to specify an IP address and removes any certificate entries with a matching Common Name (CN) from the `cert9.db` file. It also removes all occurrences of the IP address from the `cert_override.txt` file.

## Prerequisites

- Mozilla NSS tools must be installed.
- The script assumes a default Firefox profile directory location: `$HOME/Library/Application Support/Firefox/Profiles`.

## Usage

1. Make the script executable:

   ```bash
   chmod +x remove_certificate.sh
   ```

2. Execute the script with an IP address as a command line argument:

   ```bash
   ./remove_certificate.sh <IP_ADDRESS>
   ```

   Replace `<IP_ADDRESS>` with the actual IP address you want to query for certificate CN.

3. The script will remove the certificate entries with the matching CN from the `cert9.db` file and remove all occurrences of the IP address from the `cert_override.txt` file.

4. The script will display success messages if the removal process is completed successfully. Otherwise, it will display error messages with possible causes.

## Notes

- The script uses the `certutil` command to interact with the `cert9.db` file (or cert8.db file under profile directory). Please ensure that the `certutil` command is available and correctly installed.
- The script assumes a default Firefox profile directory location. If your profile directory is different, you need to modify the `PROFILE_DIRECTORY` variable in the script accordingly.
- The script assumes that the `cert_override.txt` file is present in the profile directory. If it is not found, the script will display an error message.
- The script removes certificates based on the CN info. Ensure that the IP address you provide corresponds to the correct CN of the certificate you want to remove.
- It has been validated on a MacOS.

## Contributing
Contributions are welcome! Here's how you can contribute to the project:

1. Fork the repository.
2. Create a new branch for your contribution.
3. Make your changes and enhancements.
4. Test your changes thoroughly.
5. Submit a pull request describing the changes you made.

Please ensure that your contributions adhere to the coding standards and guidelines used in the project.

## License

This script is licensed under the [MIT License](https://mit-license.org/).

## Author
- [Andre Gustavo Albuquerque](https://github.com/andregca)