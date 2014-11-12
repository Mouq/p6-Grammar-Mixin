use Test;
use Grammar::Mixin;

plan 3;

{
    my grammar G { token TOP { bar } }
    my $mix = G but role { rule TOP { foo <*> baz } }
    is $mix.parse("foo bar baz"), "foo bar baz";
}

{
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
    grammar HeaderCSV is CSV {
        token TOP {
            <header> \n
            <*>         # Continue in CSV's token TOP
        }
        token header {
            <col> *%% \,
        }
    }
    ok HeaderCSV.parse("a,b,c\n1,2,3");
    is $<header>, "a,b,c";
}
