#include "builtin.hpp"
#include "os/__init__.hpp"
#include "stat.hpp"
#include "os/path.hpp"
#include "sys.hpp"
#include "example1.hpp"

namespace __example1__ {

str *const_0;


str *__name__, *word;



void __init() {
    const_0 = new str("heyo");

    __name__ = new str("__main__");

    word = const_0;
    print2(NULL,0,1, word);
}

} // module namespace

int main(int __ss_argc, char **__ss_argv) {
    __shedskin__::__init();
    __stat__::__init();
    __os__::__path__::__init();
    __os__::__init();
    __sys__::__init(__ss_argc, __ss_argv);
    __shedskin__::__start(__example1__::__init);
}
