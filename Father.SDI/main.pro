% Copyright 

implement main
    open core

clauses
    run() :-
        _ = mainForm::display(window::getScreenWindow()),
        messageLoop::run().

end implement main

goal
    formWindow::run(main::run).
    