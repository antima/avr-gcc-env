import distutils.version
import subprocess
import typing
import sys
import re


desc = """
Lists the available version for the packages in the GNU packages.
Usage: ./list-versions.py PACKAGE
  -h, --help
      shows this help message
  PACKAGE
      gcc, binutils, libc
"""


def get_available_versions(pkg: str) -> typing.List[str]:
	urls = {
		"gcc": "https://gcc.gnu.org/git/gcc.git",
		"binutils": "http://sourceware.org/git/binutils-gdb.git",
		"libc": "https://github.com/avrdudes/avr-libc.git"
	}

	if pkg not in urls:
		raise ValueError("unsupported package")

	releases = []
	proc = subprocess.run(
		["git", "ls-remote", "--refs", "--tags", urls[pkg]], 
		capture_output=True
	)

	for line in proc.stdout.decode().split("\n"):
		if pkg == "gcc":
			if "/releases/gcc" not in line:
				continue
			if not re.match(".*gcc-([0-9]+)\.([0-9]+)(\.[0-9]+)?$", line):
				continue
			start = line.index("/releases/gcc-") + len("/releases/gcc-") 
			version = line[start:]
		elif pkg == "binutils":
			if "/binutils-" not in line:
				continue
			if not re.match(".*binutils-[0-9]+_[0-9]+(_[0-9]+)?$", line):
				continue
			start = line.index("/binutils-") + len("/binutils-")
			version = line[start:].replace("_", ".")
		else:
			if "release" not in line:
				continue
			start = line.index("avr-libc-") + len( "avr-libc-")
			end = line.index("-release")
			version = line[start:end].replace("_", ".")
		
		releases.append(version)

	return releases


def main():
	try:
		if len(sys.argv) != 2:
			print(desc)
			sys.exit(1)
		
		if sys.argv[1] == "-h" or sys.argv[1] == "--help":
			print(desc)
			sys.exit(0)
	
		res = get_available_versions(sys.argv[1])
		res.sort(key=distutils.version.StrictVersion)
		print(", ".join(res)) 	
	except Exception as e:
		print(f"error: {e}")
		sys.exit(1)
	

if __name__ == "__main__":
	main()
