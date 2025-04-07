# filesystem_analysis

## A. Summary

A script to generate a list of files and their respective sizes in bytes

The data collected is used for data migration planning

## B. Dependencies

It needs bash shell installed in the host

## C. Supported Systems

In theory any Unix/Linux system with bash installed

## Installation

- Clone the repository
```bash
git clone https://github.com/nobre165/filesystem_analysis.git
```

- Change the pernmission of script
```bash
cd filesystem_analysis
chmod 755 get_file_sizes.sh
```

- Run the script
```bash
./get_file_sizes.sh /fs1 /fs2 /fs3 ... /fsN
```

## Notes

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>
