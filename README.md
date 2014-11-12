Grammar::Mixin
==

WIP slang made to make making slangs easier.

Currently adds `<*>` in regexes, which will call into the regex that's being
overwritten by a mixin or because of inheritence.


    grammar CSV {
        token TOP {
            <row> *%% \n
        }
        token row {
            <col> *%% \,
        }
        token col {
            <-[\n,]>* | \"~\" <-["]>*
        }
    }
    grammar HeaderCSV {
        token TOP {
            <header> \n
            <*>         # Continue in CSV's token TOP
        }
        token header {
            <col> *%% \,
        }
    }
