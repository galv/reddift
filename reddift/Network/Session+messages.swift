//
//  Session+messages.swift
//  reddift
//
//  Created by sonson on 2015/05/19.
//  Copyright (c) 2015年 sonson. All rights reserved.
//

import Foundation

extension Session {
    
    // MARK: BDT does not cover following methods.
    
    /**
    Get the message from the specified box.
    
    - parameter messageWhere: The box from which you want to get your messages.
    - parameter limit: The maximum number of comments to return. Default is 100.
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func getMessage(messageWhere:MessageWhere, limit:Int = 100, completion:(Result<Listing>) -> Void) -> NSURLSessionDataTask? {
        guard let request = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/message" + messageWhere.path, method:"GET", token:token) else { return nil }
        let task = URLSession.dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            self.updateRateLimitWithURLResponse(response)
            let result = resultFromOptionalError(Response(data: data, urlResponse: response), optionalError:error)
                .flatMap(response2Data)
                .flatMap(data2Json)
                .flatMap(json2RedditAny)
                .flatMap(redditAny2Listing)
            completion(result)
        })
        task.resume()
        return task
    }
    
    /**
    Compose new message to specified user.
    
    - parameter to: Account object of user to who you want to send a message.
    - parameter subject: A string no longer than 100 characters
    - parameter text: Raw markdown text
    - parameter fromSubreddit: Subreddit name?
    - parameter captcha: The user's response to the CAPTCHA challenge
    - parameter captchaIden: The identifier of the CAPTCHA challenge
    - parameter completion: The completion handler to call when the load request is complete.
    - returns: Data task which requests search to reddit.com.
    */
    public func composeMessage(to:Account, subject:String, text:String, fromSubreddit:Subreddit, captcha:String, captchaIden:String, completion:(Result<JSON>) -> Void) -> NSURLSessionDataTask? {
        var parameter:[String:String] = [:]
        
        parameter["api_type"] = "json"
        parameter["captcha"] = captcha
        parameter["iden"] = captchaIden
        
        parameter["from_sr"] = fromSubreddit.displayName
        parameter["text"] = text
        parameter["subject"] = subject
        parameter["to"] = to.id
        
        guard let request:NSMutableURLRequest = NSMutableURLRequest.mutableOAuthRequestWithBaseURL(baseURL, path:"/api/submit", parameter:parameter, method:"POST", token:token) else { return nil }
        return handleAsJSONRequest(request, completion:completion)
    }
}