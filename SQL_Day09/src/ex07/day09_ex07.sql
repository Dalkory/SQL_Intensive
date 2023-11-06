CREATE FUNCTION func_minimum(VARIADIC arr numeric[]) RETURNS numeric AS
$$
BEGIN
    RETURN (
        SELECT MIN(arr[i])
        FROM GENERATE_SUBSCRIPTS(arr, 1) AS i
    );
END
$$ LANGUAGE plpgsql;

SELECT func_minimum(VARIADIC ARRAY[10.0, -1.0, 5.0, 4.4]);