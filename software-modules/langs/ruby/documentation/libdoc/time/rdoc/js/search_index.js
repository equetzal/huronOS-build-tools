var search_data = {"index":{"searchIndex":["time","httpdate()","httpdate()","iso8601()","iso8601()","parse()","rfc2822()","rfc2822()","rfc822()","rfc822()","strptime()","xmlschema()","xmlschema()","zone_offset()"],"longSearchIndex":["time","time::httpdate()","time#httpdate()","time::iso8601()","time#iso8601()","time::parse()","time::rfc2822()","time#rfc2822()","time::rfc822()","time#rfc822()","time::strptime()","time::xmlschema()","time#xmlschema()","time::zone_offset()"],"info":[["Time","","Time.html","",""],["httpdate","Time","Time.html#method-c-httpdate","(date)","<p>Parses <code>date</code> as an HTTP-date defined by RFC 2616 and converts it to a Time object.\n<p>ArgumentError is raised …\n"],["httpdate","Time","Time.html#method-i-httpdate","()","<p>Returns a string which represents the time as RFC 1123 date of HTTP-date defined by RFC 2616:\n\n<pre>day-of-week, ...</pre>\n"],["iso8601","Time","Time.html#method-c-iso8601","(date)",""],["iso8601","Time","Time.html#method-i-iso8601","(fraction_digits=0)",""],["parse","Time","Time.html#method-c-parse","(date, now=self.now)","<p>Takes a string representation of a Time and attempts to parse it using a heuristic.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;time&#39;</span>\n\n<span class=\"ruby-constant\">Time</span>.<span class=\"ruby-identifier\">parse</span>(<span class=\"ruby-string\">&quot;2010-10-31&quot;</span>) <span class=\"ruby-operator\">...</span>\n</pre>\n"],["rfc2822","Time","Time.html#method-c-rfc2822","(date)","<p>Parses <code>date</code> as date-time defined by RFC 2822 and converts it to a Time object.  The format is identical …\n"],["rfc2822","Time","Time.html#method-i-rfc2822","()","<p>Returns a string which represents the time as date-time defined by RFC 2822:\n\n<pre>day-of-week, DD month-name ...</pre>\n"],["rfc822","Time","Time.html#method-c-rfc822","(date)",""],["rfc822","Time","Time.html#method-i-rfc822","()",""],["strptime","Time","Time.html#method-c-strptime","(date, format, now=self.now)","<p>Works similar to <code>parse</code> except that instead of using a heuristic to detect the format of the input string, …\n"],["xmlschema","Time","Time.html#method-c-xmlschema","(date)","<p>Parses <code>date</code> as a dateTime defined by the XML Schema and converts it to a Time object.  The format is …\n"],["xmlschema","Time","Time.html#method-i-xmlschema","(fraction_digits=0)","<p>Returns a string which represents the time as a dateTime defined by XML Schema:\n\n<pre>CCYY-MM-DDThh:mm:ssTZD ...</pre>\n"],["zone_offset","Time","Time.html#method-c-zone_offset","(zone, year=self.now.year)","<p>Return the number of seconds the specified time zone differs from UTC.\n<p>Numeric time zones that include …\n"]]}}