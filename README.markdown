dyno
====

> _A dynamometer or "dyno" for short, is a machine used to measure torque and
> rotational speed (rpm) from which power produced by an engine, motor or
> other rotating prime mover can be calculated. ([Wikipedia][dyno-wp])_

In this context, however, Dyno is a pure Ruby library for parsing sim-racing
result files, soon to be used on the upcoming Torque sim-racing app.

Dyno presently supports files spat out by a number of games:

* **Race07Parser** parses results from RACE 07, GTR: Evolution, and
  STCC: The Game
* **GTR2Parser** parses results from GTR2.
* **RFactorParser** parses results from rFactor (and mods), and ARCA (coming
  very soon).

Dyno requires the iniparse gem (available via `gem install iniparse` or on
[GitHub][iniparse]) for the Race 07 and GTR2 parsers, and libxml-ruby for
the rFactor parser.

Usage
-----

    Dyno::Parsers::Race07Parser.parse_file( '/path/to/result/file' )
    # => Dyno::Event

    Dyno::Parsers::GTR2Parser.parse_file( '/path/to/result/file' )
    # => Dyno::Event

    Dyno::Parsers::RFactorParser.parse_file( '/path/to/result/file' )
    # => Dyno::Event

Each of these operations will return a Dyno::Event instance. Dyno::Event
defines `#competitors` containing a collection of all of those who took part
in the event. See the API docs for Dyno::Event and Dyno::Competitor for more
details.

If your results file couldn't be parsed, a Dyno::MalformedInputError exception
will be raised.

License
-------

Dyno is distributed under the MIT/X11 License.

> Copyright (c) 2008-2009 Anthony Williams
>
> Permission is hereby granted, free of charge, to any person obtaining a copy
> of this software and associated documentation files (the "Software"), to
> deal in the Software without restriction, including without limitation the
> rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
> sell copies of the Software, and to permit persons to whom the Software is
> furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in
> all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
> IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
> FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
> AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
> LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
> FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
> IN THE SOFTWARE.

[dyno-wp]:  http://en.wikipedia.org/wiki/Dynamometer "Wikipedia"
[iniparse]: http://github.com/anthonyw/iniparse "IniParse on GitHub"
