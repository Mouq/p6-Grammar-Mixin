use QAST:from<NQP>;

my role Callsame::Grammar {
    token assertion:sym<*> {
        <sym>
    }
}
my role Callsame::Actions {
    method assertion:sym<*> (Mu $/) {
        $/.make: QAST::Regex.new: QAST::NodeList.new(
            QAST::SVal.new( :value<INTERPOLATE> ),
            # XXX next_candidate or something
            QAST::Op.new( :op<atpos>,
                QAST::Op.new( :op<callmethod>, :name<candidates>,
                    QAST::Op.new( :op<p6finddispatcher>, QAST::SVal.new( :value<callsame> ))
                ),
                QAST::IVal.new( :value(1) )
            ),
            QAST::IVal.new( :value(%*RX<i> ?? 1 !! 0) ),
            QAST::IVal.new( :value($*SEQ ?? 1 !! 0) ),
        ), :rxtype<subrule>, :subtype<method>, :node($/);
    }
}

sub slangify ($role, :$into = 'MAIN') {
    nqp::bindkey(%*LANG, $into, %*LANG{$into}.HOW.mixin(%*LANG{$into}, $role));
}

sub EXPORT {
    slangify Callsame::Grammar, :into<Regex>;
    slangify Callsame::Actions, :into<Regex-actions>;
    {}
}
