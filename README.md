# Template for building python documentation with Sphinx

## Usage
Put the contents into the docs folder of the package that needs to be documented.

Ensure that you have all the requirements:
```
make .deps
```

### Change the name of the package
Edit `conf.py`:
* lines 44-47
* line 54
* lines 100-109

Edit `Makefile` lines 19, 41, 42.

Edit `.rst` files, add new if necessary.

Add the example notebooks in the `examples` folder in the root project directory. 

#### Run
```
make html
```
Open `build\html\index.html`


