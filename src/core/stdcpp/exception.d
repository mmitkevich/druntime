// Written in the D programming language.

/**
 * Interface to C++ <exception>
 *
 * Copyright: Copyright (c) 2016 D Language Foundation
 * License:   $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).
 * Authors:   $(HTTP digitalmars.com, Walter Bright)
 * Source:    $(DRUNTIMESRC core/stdcpp/_exception.d)
 */

module core.stdcpp.exception;

alias exception = std.exception;
alias bad_exception = std.bad_exception;
alias bad_alloc = std.bad_alloc;

extern (C++, std):

version (CRuntime_DigitalMars)
{
    import core.stdcpp.typeinfo;

    alias void function() unexpected_handler;
    unexpected_handler set_unexpected(unexpected_handler f) nothrow;
    void unexpected();

    alias void function() terminate_handler;
    terminate_handler set_terminate(terminate_handler f) nothrow;
    void terminate();

    bool uncaught_exception();

    class exception
    {
        this() nothrow { }
        this(const exception) nothrow { }
        //exception operator=(const exception) nothrow { return this; }
        //virtual ~this() nothrow;
        void dtor() { }
        const(char)* what() const nothrow;
    }

    class bad_exception : exception
    {
        this() nothrow { }
        this(const bad_exception) nothrow { }
        //bad_exception operator=(const bad_exception) nothrow { return this; }
        //virtual ~this() nothrow;
        override const(char)* what() const nothrow;
    }
}
else version (CRuntime_Glibc)
{
    alias void function() unexpected_handler;
    unexpected_handler set_unexpected(unexpected_handler f) nothrow;
    void unexpected();

    alias void function() terminate_handler;
    terminate_handler set_terminate(terminate_handler f) nothrow;
    void terminate();

    pure bool uncaught_exception();

    class exception
    {
        this();
        //virtual ~this();
        void dtor1();
        void dtor2();
        const(char)* what() const;
    }

    class bad_exception : exception
    {
        this();
        //virtual ~this();
        override const(char)* what() const;
    }
}
else version (CRuntime_Microsoft)
{
    class exception
    {
        this(const(char)* _Message = "unknown", int x = 1) { _Ptr = _Message; }
        this(ref const(exception) _Right) { _Ptr = _Right._Ptr; }
        ~this() {}

        const(char)* what() const { return _Ptr ? _Ptr : "unknown exception"; }

    private:
        const(char)* _Ptr;
    }

    class bad_exception : exception
    {
        this(const(char)* _Message = "bad exception") { super(_Message); }
        ~this() {}
    }

    class bad_alloc : exception
    {
        this() { super("bad allocation", 1); }
        ~this() {}
    }
}
