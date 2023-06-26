def lambda_handler(event, context):
    """
    This code is a Lambda function that uses list operations to filter the even numbers in a
    list of numbers and calculate the sum of those even numbers. The function returns a JSON
    response with the calculated sum.

    Returns:
        dict: response data
            - statusCode (int): response status
            - body (dict): response with the sum of the even numbers
    """
    # Define a list of numbers
    numbers = [2, 4, 6, 8, 10]

    # Filter the even numbers in the list
    even_numbers = list(filter(lambda x: x % 2 == 0, numbers))

    # Calculate the sum of the even numbers
    total = sum(even_numbers)

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": {"sum": total},
    }
