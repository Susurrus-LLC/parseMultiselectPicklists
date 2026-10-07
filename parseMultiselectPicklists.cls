/**
 * @author Ian Cook
 * @description Takes the values from a multiselect picklist field and parses them into a List of Strings
 */
public with sharing class parseMultiselectPicklists {
    /** Set the delimiter used to parse the multi-select picklist values */
    private static final String DELIMITER = ';';

    /** A subclass to define the type for the invocable method's input */
    public class Request {
        @invocableVariable(
            label='Multi-Select Picklist Value'
            description='The raw value, e.g., \'Red;Blue;Green\''
            required=true
        )
        public String picklistValue;
    }

    /** A subclass to define the type for the invocable method's response */
    public class Response {
        @invocableVariable(
            label='Parsed Values'
            description='A collection, one string per selected picklist value'
        )
        public List<String> values;
    }

    /**
     * @description Given a delimited string, parse it with the DELIMITER to return a List of Strings
     * @param rawValue The raw string value from a multi-select picklist
     * @return Each of the values parsed into a List of Strings
     */
    @TestVisible
    private static List<String> splitValue(String rawValue) {
        if (String.isBlank(rawValue)) {
            return new List<String>();
        }
        return rawValue.split(DELIMITER);
    }

    /**
     * @description The invocable method that takes a List of Requests and parses them into a List of Responses
     * @param requests A List of Requests, each of which contains the raw multi-select picklist values string
     * @return a List of Responses, each of which contains a List of Strings representing the parsed picklist values
     */
    @InvocableMethod(
        label='Parse Multi-Select Picklist'
        description='Splits a multi-select picklist value into a collection of string values'
        category='Utilities'
    )
    public static List<Response> parse(List<Request> requests) {
        List<Response> responses = new List<Response>();

        for (Request req : requests) {
            Response res = new Response();
            res.values = splitValue(req?.picklistValue);
            responses.add(res);
        }

        return responses;
    }
}