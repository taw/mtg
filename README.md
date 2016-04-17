mtg
===

Magic the Gathering scripts.

scripts
=======

* `analyze_deck_colors` - reports colors of the deck according to correct algorithm [ http://t-a-w.blogspot.com/2013/03/simple-and-correct-algorithm-for.html ]
* `clean_up_decklist` - clean up manually created decklist
* `txt2cod` - convert plaintext deck formats to Cockatrice's cod
* `cod2txt` - convert Cockatrice's .cod to .txt format
* `cod2dck` - convert Cockatrice's .cod to XMage's .dck
* `url2cod` - download decklists from URL and convert to .cod (a few popular websites supported)


data management
===============

These are used to generate data in `data/`, you probably won't need to run them yourself

* `generate_colors_tsv_mtgjson` - generate `data/colors.tsv` from mtgjson's AllSets-x.json (recommended)
* `generate_colors_tsv_cockatrice` - generate `data/colors.tsv` from cockatrice's cards.xml (use mtgjson instead)
