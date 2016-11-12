implement main

    open core

    domains

        gender = female(); male().

    class facts - familyDB

        person : (string Name, gender Gender).

        parent : (string Person, string Parent).

    class predicates

        father : (string Person, string Father) nondeterm anyflow.

    clauses

        father(Person, Father) :-

            parent(Person, Father),

            person(Father, male()).

    class predicates

        grandFather : (string Person, string GrandFather) nondeterm (o,o).

    clauses

        grandFather(Person, GrandFather) :-

            parent(Person, Parent),

            father(Parent, GrandFather).

    class predicates

        ancestor : (string Person, string Ancestor) nondeterm (i,o).

    clauses

        ancestor(Person, Ancestor) :-

            parent(Person, Ancestor).

        ancestor(Person, Ancestor) :-

            parent(Person, P1),

            ancestor(P1, Ancestor).

    class predicates

        reconsult : (string FileName).

    clauses

        reconsult(FileName) :-

            retractFactDB(familyDB),

            file::consult(FileName, familyDB).

    clauses

        run():-

            console::init(),

            stdIO::write("Load data\n"),

            reconsult("..\\fa.txt"),

            stdIO::write("\nfather test\n"),

            father(X, Y),

                stdIO::writef("% is the father of %\n", Y, X),

            fail.

        run():-

            stdIO::write("\ngrandFather test\n"),

            grandFather(X, Y),

                stdIO::writef("% is the grandfather of %\n", Y, X),

            fail.

        run():-

            stdIO::write("\nancestor of Pam test\n"),

            X = "Pam",

            ancestor(X, Y),

                stdIO::writef("% is the ancestor of %\n", Y, X),

            fail.

        run():-

            stdIO::write("End of test\n").

end implement main

goal

    mainExe::run(main::run).
