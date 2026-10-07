@IsTest
private class parseMultiselectPicklistsTest {
    private static parseMultiselectPicklists.Request buildRequest(String value) {
        parseMultiselectPicklists.Request req = new parseMultiselectPicklists.Request();
        req.picklistValue = value;
        return req;
    }

    @IsTest
    static void parsesMultipleValues() {
        List<parseMultiselectPicklists.Request> requests = new List<parseMultiselectPicklists.Request>{
            buildRequest('Red;Blue;Green')
        };

        List<parseMultiselectPicklists.Response> responses = parseMultiselectPicklists.parse(requests);

        Assert.areEqual(
            1,
            responses.size(),
            'Expected one Response per Request'
        );
        Assert.areEqual(
            new List<String>{ 'Red', 'Blue', 'Green' },
            responses[0].values,
            'Values should be split on semicolons, in order'
        );
    }

    @IsTest
    static void parsesSingleValue() {
        List<parseMultiselectPicklists.Response> responses = parseMultiselectPicklists.parse(
            new List<parseMultiselectPicklists.Request>{ buildRequest('Red') }
        );

        Assert.areEqual(
            new List<String>{ 'Red' },
            responses[0].values,
            'A single value should return without issue'
        );
    }

    @IsTest
    static void returnsEmptyListForNullOrBlank() {
        List<parseMultiselectPicklists.Request> requests = new List<parseMultiselectPicklists.Request>{
            buildRequest(null),
            buildRequest(''),
            buildRequest('   ')
        };

        List<parseMultiselectPicklists.Response> responses = parseMultiselectPicklists.parse(requests);

        Assert.areEqual(3, responses.size(), 'Every Request still gets a Response');
        for (parseMultiselectPicklists.Response res : responses) {
            Assert.isNotNull(
                res.values,
                'Should be an empty list, never null'
            );
            Assert.isTrue(
                res.values.isEmpty(),
                'Blank input should yield no values'
            );
        }
    }

    @IsTest
    static void preservesOrder() {
        List<parseMultiselectPicklists.Request> requests = new List<parseMultiselectPicklists.Request>{
            buildRequest('A;B'),
            buildRequest(null),
            buildRequest('C;D;E')
        };

        List<parseMultiselectPicklists.Response> responses = parseMultiselectPicklists.parse(requests);

        Assert.areEqual(3, responses.size());
        Assert.areEqual(new List<String>{ 'A', 'B' }, responses[0].values);
        Assert.areEqual(0, responses[1].values.size());
        Assert.areEqual(new List<String>{ 'C', 'D', 'E' }, responses[2].values);
    }

    @IsTest
    static void handlesBulkVolume() {
        List<parseMultiselectPicklists.Request> requests = new List<parseMultiselectPicklists.Request>();
        for (Integer i = 0; i < 200; i++) {
            requests.add(buildRequest('X' + i + ';Y' + i));
        }

        List<parseMultiselectPicklists.Response> responses = parseMultiselectPicklists.parse(requests);

        Assert.areEqual(200, responses.size());
        Assert.areEqual(new List<String>{ 'X199', 'Y199' }, responses[199].values);
    }

    @IsTest
    static void handlesMalformedInput() {
        Assert.areEqual(
            new List<String>{ 'A', 'B' },
            parseMultiselectPicklists.splitValue('A;B;'),
            'Trailing delimiter is dropped by split()'
        );
        Assert.areEqual(
            new List<String>{ '', 'A' },
            parseMultiselectPicklists.splitValue(';A'),
            'Leading delimiter yields an empty first element'
        );
    }
}