# Webster's 1913 for Kobo

This repository builds Webster's Unabridged Dictionary (1913) as a Kobo
dictionary. The dictionary is an extra dictionary in the device's list, and
Kobo's own dictionaries stay as they are. It has 113,183 entries.

The source is the [Project Gutenberg text](https://www.gutenberg.org/ebooks/29765).
The conversion is done by Patrick Gaskin's
[dictutil](https://github.com/pgaskin/dictutil): `webster1913-convert` parses
the Gutenberg text into a dictfile, and `dictgen` packs the dictfile into a
Kobo dictzip. The dictutil docs link a prebuilt copy, but that link points to
a CI artifact that no longer exists. This repository builds the same thing
and puts the result on the releases page.

## Download

Get `dicthtml-wb.zip` from the
[latest release](https://github.com/ahacop/kobo-webster1913/releases/latest).
The release also has `webster1913.df.gz`, the dictfile, in case you want to
change the entries and pack them again with `dictgen`.

## Install

Custom dictionaries work without a patch on firmware 4.24.15672 and later.
The dictionary works on a Kobo with firmware 4.38.23697.

The easy way is `dictutil install`. Connect the Kobo, then run:

```sh
dictutil install dicthtml-wb.zip
```

To install by hand, do the same three things that `dictutil install` does:

1. Copy `dicthtml-wb.zip` to `.kobo/dict/` on the Kobo.
2. Make the file read-only, so that a Kobo sync does not delete it.
3. Add `ExtraLocales=wb` under `[ApplicationPreferences]` in
   `.kobo/Kobo/Kobo eReader.conf`. If the key is there already, add `wb` to
   its list.

Eject the Kobo. Then turn the dictionary on in Settings, under Language and
dictionaries. It has the name "wb".

## Build

The build needs Go and a C compiler, because the dictutil tools use cgo.
`nix develop` gives both.

```sh
nix develop -c ./build.sh
```

The script compiles dictutil v0.3.2 into `bin/` and downloads the Gutenberg
text into `build/`. Then it writes `build/webster1913.df` and
`build/dicthtml-wb.zip`, and prints their SHA-256 sums. The build is
reproducible: the same Gutenberg text gives the same zip, byte for byte.
After the build, `bin/dictutil install build/dicthtml-wb.zip` installs the
dictionary.

## Notes on the entries

Each entry is indexed under its headword and under the forms and phrases
that the entry lists. For example, the entry for "run" is also indexed under
"running" and "to run out". Plurals and third-person forms, such as "dogs"
and "runs", are not in the index.

The definitions come from a 1913 dictionary. Some spellings, senses, and
views are of that time.

## License

The build script and the Nix file are under the MIT license. The dictionary
text is in the public domain in the United States. dictutil is under the MIT
license.
