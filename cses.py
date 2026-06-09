import shutil as sh
from pathlib import Path

config = Path("config")
if not config.is_file(): print("make config file"); exit(1)
cm = {pair.split("=")[0]:pair.split("=")[1].strip("\"") for pair in config.read_text().strip().split("\n")}
tests_zip = Path(f"{cm["downloads"]}/tests.zip")
if not tests_zip.is_file(): print("download tests"); exit(1)

id = int(input("enter id: "))
root = Path(f"{id}")
tests = root / 'tests'
try:
    root.mkdir()
except FileExistsError:
    print("directory already created")
try:
    tests.mkdir()
except FileExistsError:
    print("tests directory already created")
sh.copy(tests_zip, tests)
sh.unpack_archive(tests / "tests.zip", tests)
(tests/"tests.zip").unlink()
sh.copy("template.cpp", root/"sol.cpp")
