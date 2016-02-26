{seznam chybových hlášek komplexu gpl2}

unit chyby;
interface
uses together;

const pocetchybovychhlasek=60;
      chybhlasky:array[1..pocetchybovychhlasek]of string=(
{ident} 'missing file ' + jmsoubident + ' with identifier definitions',
        'expecting 1 class number after CLASS',
        'expecting a class name before an identifier',
        'identifier has already been defined',
        'too long identifier',
        'identifier names can only contain letters, numbers, and _',
        'expecting 1 number after the identifier',
        'identified values must be an integer',
        'class numbers must form a sequence 1..N',
        {1..9}
{comm}  'missing file ' + jmsoubprik + ' with command definitions',
        'too long command name',
        'command names can only contain letters, numbers, and _',
        'only 1 command can be flagged by TALK',
        'expecting command number',
        'invalid command number',
        'expecting command sub-number',
        'invalid command sub-number',
        'command has too many parameters',
        'sub-types are only available for types 2 and 3',
        'invalid sub-type',
        'invalid type',
        'TALK command needs 2 parameters: identifier and right string',
        'command has already been defined',
        'multiple commands of the same number and with different parameters',
        'command numbers must form a sequence 1..N',
        'command sub-numbers must form a sequence 1..N',
        'exactly 1 command flagged by TALK must be defined',
        {10..27}
{mat2bin}'number expected after word nahoda (= random)',
        {28}
{gpl2}  'mathematical expression must end on the same line ()',
        '\ can only occur at the end of the line and means continuation',
        'invalid token encountered',
        'unterminated command at the end of file',
        'invalid number',
{dont't use!}        'error in math.expr.: number expected after word nahoda (= random)',
        'colon can only be used for TALK: <name>: "<string>"',
        '(internal) invalid token and it passed the first check!',
        '0th command parameter must be its name',
        'LABELS can only occur at the beginning of a program',
        'LABELS expects a list of labels',
        'defining label with name colliding with an identifier',
        'label has already been defined',
        'LABEL expects 1 parameter: label name',
        'no label declared',
        'multiple label definition',
        'invalid command',
        'invalid command parameter: indentifier of another type',
        'unknown identifier',
        'identifier expected, not label',
        '(internal) unknown parameter type',
        'undefined label',
{added at random places, before if was sequential, and each used just once}
        'too many parameters for the command', {2 times}
        {29..51}
{mat2bin}'unknown identifier in math.expr.',
        'invalid operator in math.expr.',
        'expecting operator and not a number',
        'expecting operator and not an identifier',
        'expecting number (or function) and not an operator',
        'expecting number and not )',
        'expecting number and not the end of math.expr.',
        'expecting operator and not a function',
        'expecting operator and not (');

implementation

end.
