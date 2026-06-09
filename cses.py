'''
so it seems the api is pretty blocked off shall
we start with the problem open
manually download test cases to download folder

scripted:
    create directory for this problem
    pull zip folder into directory
    inflate
    extract testcases into tests folder
    copy template to folder
    build sol
    run sol against tests

manually submit to site
'''
import shutil as sh
from pathlib import Path

id = int(input("enter id: "))
root = Path(f"{id}")
tests = root / 'tests'
try:
    root.mkdir()
except FileExistsError:
    print("directory already created")
try:
    tests.mkdir()
except:
    print("tests directory already created")
sh.copy("/Users/jujhaarb/Downloads/tests.zip", tests)
sh.unpack_archive(tests / "tests.zip", tests)
(tests/"tests.zip").unlink()
sh.copy("template.cpp", root/"sol.cpp")
