#
#
#


import HTTP


function main()
    println("Start lambda")
    try
        awsLambdaRuntimeApi = ENV("AWS_LAMBDA_RUNTIME_API")
        if awsLambdaRuntimeApi === nothing
            println("Error AWS_LAMBDA_RUNTIME_API is not available.")
            exit(1)
        end
    catch
        println("Error AWS_LAMBDA_RUNTIME_API is not available.")
        exit(1)
    end
    println(awsLambdaRuntimeApi)
    while true
        uri = HTTP.request("GET", "http://" * awsLambdaRuntimeApi * "/2018-06-01/runtime/invocation/next")
        println("uri : ", uri);
        try
            requestId = uri.headers.Lambda-Runtime-Aws-Request-Id
            body = uri.body
            println(String(body))
            payload = "{\"receive\":" * body * "}"
            result = HTTP.request("POST", "http://"
                                  * awsLambdaRuntimeApi
                                  * "/2018-06-01/runtime/invocation/"
                                  * requestId
                                  * "/response")
            println(result.statusCode)
            println(String(result.body))
        catch
            stacktrace()
        end

    end
    
end


if length(PROGRAM_FILE)!=0 && occursin(PROGRAM_FILE, @__FILE__)
    main()
end
