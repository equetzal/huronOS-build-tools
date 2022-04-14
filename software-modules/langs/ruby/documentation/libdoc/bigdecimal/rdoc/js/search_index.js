var search_data = {"index":{"searchIndex":["bigdecimal","bigmath","float","integer","jacobian","kernel","lusolve","newton","nilclass","rational","string","%()","*()","**()","+()","+@()","-()","-@()","/()","<()","<=()","<=>()","==()","===()",">()",">=()","bigdecimal()","e()","pi()","_dump()","_load()","abs()","add()","atan()","ceil()","clone()","coerce()","cos()","dfdxi()","div()","divmod()","double_fig()","dup()","eql?()","exp()","exponent()","finite?()","fix()","floor()","frac()","hash()","infinite?()","inspect()","interpret_loosely()","isequal()","jacobian()","limit()","log()","ludecomp()","lusolve()","mode()","modulo()","mult()","nan?()","nlsolve()","nonzero?()","power()","precs()","quo()","remainder()","round()","save_exception_mode()","save_limit()","save_rounding_mode()","sign()","sin()","split()","sqrt()","sqrt()","sub()","to_d()","to_d()","to_d()","to_d()","to_d()","to_d()","to_digits()","to_f()","to_i()","to_int()","to_r()","to_s()","truncate()","zero?()"],"longSearchIndex":["bigdecimal","bigmath","float","integer","jacobian","kernel","lusolve","newton","nilclass","rational","string","bigdecimal#%()","bigdecimal#*()","bigdecimal#**()","bigdecimal#+()","bigdecimal#+@()","bigdecimal#-()","bigdecimal#-@()","bigdecimal#/()","bigdecimal#<()","bigdecimal#<=()","bigdecimal#<=>()","bigdecimal#==()","bigdecimal#===()","bigdecimal#>()","bigdecimal#>=()","kernel#bigdecimal()","bigmath#e()","bigmath#pi()","bigdecimal#_dump()","bigdecimal::_load()","bigdecimal#abs()","bigdecimal#add()","bigmath#atan()","bigdecimal#ceil()","bigdecimal#clone()","bigdecimal#coerce()","bigmath#cos()","jacobian#dfdxi()","bigdecimal#div()","bigdecimal#divmod()","bigdecimal::double_fig()","bigdecimal#dup()","bigdecimal#eql?()","bigmath::exp()","bigdecimal#exponent()","bigdecimal#finite?()","bigdecimal#fix()","bigdecimal#floor()","bigdecimal#frac()","bigdecimal#hash()","bigdecimal#infinite?()","bigdecimal#inspect()","bigdecimal::interpret_loosely()","jacobian#isequal()","jacobian#jacobian()","bigdecimal::limit()","bigmath::log()","lusolve#ludecomp()","lusolve#lusolve()","bigdecimal::mode()","bigdecimal#modulo()","bigdecimal#mult()","bigdecimal#nan?()","newton#nlsolve()","bigdecimal#nonzero?()","bigdecimal#power()","bigdecimal#precs()","bigdecimal#quo()","bigdecimal#remainder()","bigdecimal#round()","bigdecimal::save_exception_mode()","bigdecimal::save_limit()","bigdecimal::save_rounding_mode()","bigdecimal#sign()","bigmath#sin()","bigdecimal#split()","bigdecimal#sqrt()","bigmath#sqrt()","bigdecimal#sub()","bigdecimal#to_d()","float#to_d()","integer#to_d()","nilclass#to_d()","rational#to_d()","string#to_d()","bigdecimal#to_digits()","bigdecimal#to_f()","bigdecimal#to_i()","bigdecimal#to_int()","bigdecimal#to_r()","bigdecimal#to_s()","bigdecimal#truncate()","bigdecimal#zero?()"],"info":[["BigDecimal","","BigDecimal.html","","<p>BigDecimal provides arbitrary-precision floating point decimal arithmetic.\n<p>Introduction\n<p>Ruby provides built-in …\n"],["BigMath","","BigMath.html","","<p>Provides mathematical functions.\n<p>Example:\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&quot;bigdecimal/math&quot;</span>\n\n<span class=\"ruby-identifier\">include</span> <span class=\"ruby-constant\">BigMath</span>\n\n<span class=\"ruby-identifier\">a</span> = <span class=\"ruby-constant\">BigDecimal</span>((<span class=\"ruby-constant\">PI</span>(<span class=\"ruby-value\">100</span>)<span class=\"ruby-operator\">/</span><span class=\"ruby-value\">2</span>).<span class=\"ruby-identifier\">to_s</span>) <span class=\"ruby-operator\">...</span>\n</pre>\n"],["Float","","Float.html","",""],["Integer","","Integer.html","",""],["Jacobian","","Jacobian.html","","<p>require &#39;bigdecimal/jacobian&#39;\n<p>Provides methods to compute the Jacobian matrix of a set of equations …\n"],["Kernel","","Kernel.html","",""],["LUSolve","","LUSolve.html","","<p>Solves a*x = b for x, using LU decomposition.\n"],["Newton","","Newton.html","","<p>newton.rb\n<p>Solves the nonlinear algebraic equation system f = 0 by Newton&#39;s method. This program is …\n"],["NilClass","","NilClass.html","",""],["Rational","","Rational.html","",""],["String","","String.html","",""],["%","BigDecimal","BigDecimal.html#method-i-25","(p1)","<p>Returns the modulus from dividing by b.\n<p>See BigDecimal#divmod.\n"],["*","BigDecimal","BigDecimal.html#method-i-2A","(p1)","<p>Multiply by the specified value.\n<p>e.g.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span>.<span class=\"ruby-identifier\">mult</span>(<span class=\"ruby-identifier\">b</span>,<span class=\"ruby-identifier\">n</span>)\n<span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span> <span class=\"ruby-operator\">*</span> <span class=\"ruby-identifier\">b</span>\n</pre>\n"],["**","BigDecimal","BigDecimal.html#method-i-2A-2A","(p1)","<p>Returns the value raised to the power of n.\n<p>See BigDecimal#power.\n"],["+","BigDecimal","BigDecimal.html#method-i-2B","(p1)","<p>Add the specified value.\n<p>e.g.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span>.<span class=\"ruby-identifier\">add</span>(<span class=\"ruby-identifier\">b</span>,<span class=\"ruby-identifier\">n</span>)\n<span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span> <span class=\"ruby-operator\">+</span> <span class=\"ruby-identifier\">b</span>\n</pre>\n"],["+@","BigDecimal","BigDecimal.html#method-i-2B-40","()","<p>Return self.\n\n<pre class=\"ruby\"><span class=\"ruby-operator\">+</span><span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;5&#39;</span>)  <span class=\"ruby-comment\">#=&gt; 0.5e1</span>\n</pre>\n"],["-","BigDecimal","BigDecimal.html#method-i-2D","(p1)","<p>Subtract the specified value.\n<p>e.g.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span> <span class=\"ruby-operator\">-</span> <span class=\"ruby-identifier\">b</span>\n</pre>\n"],["-@","BigDecimal","BigDecimal.html#method-i-2D-40","()","<p>Return the negation of self.\n\n<pre class=\"ruby\"><span class=\"ruby-operator\">-</span><span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;5&#39;</span>)  <span class=\"ruby-comment\">#=&gt; -0.5e1</span>\n</pre>\n"],["/","BigDecimal","BigDecimal.html#method-i-2F","(p1)","<p>Divide by the specified value.\n<p>See BigDecimal#div.\n"],["<","BigDecimal","BigDecimal.html#method-i-3C","(p1)","<p>Returns true if a is less than b.\n<p>Values may be coerced to perform the comparison (see ==, BigDecimal#coerce …\n"],["<=","BigDecimal","BigDecimal.html#method-i-3C-3D","(p1)","<p>Returns true if a is less than or equal to b.\n<p>Values may be coerced to perform the comparison (see ==, …\n"],["<=>","BigDecimal","BigDecimal.html#method-i-3C-3D-3E","(p1)","<p>The comparison operator. a &lt;=&gt; b is 0 if a == b, 1 if a &gt; b, -1 if a &lt; b.\n"],["==","BigDecimal","BigDecimal.html#method-i-3D-3D","(p1)","<p>Tests for value equality; returns true if the values are equal.\n<p>The == and === operators and the eql? …\n"],["===","BigDecimal","BigDecimal.html#method-i-3D-3D-3D","(p1)","<p>Tests for value equality; returns true if the values are equal.\n<p>The == and === operators and the eql? …\n"],[">","BigDecimal","BigDecimal.html#method-i-3E","(p1)","<p>Returns true if a is greater than b.\n<p>Values may be coerced to perform the comparison (see ==, BigDecimal#coerce …\n"],[">=","BigDecimal","BigDecimal.html#method-i-3E-3D","(p1)","<p>Returns true if a is greater than or equal to b.\n<p>Values may be coerced to perform the comparison (see …\n"],["BigDecimal","Kernel","Kernel.html#method-i-BigDecimal","(*args)","<p>Create a new BigDecimal object.\n<p>initial &mdash; The initial value, as an Integer, a Float, a Rational, a BigDecimal …\n"],["E","BigMath","BigMath.html#method-i-E","(prec)","<p>Computes e (the base of natural logarithms) to the specified number of digits of precision, <code>numeric</code>. …\n"],["PI","BigMath","BigMath.html#method-i-PI","(prec)","<p>Computes the value of pi to the specified number of digits of precision, <code>numeric</code>.\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">BigMath</span>.<span class=\"ruby-constant\">PI</span>(<span class=\"ruby-value\">10</span>).<span class=\"ruby-identifier\">to_s</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["_dump","BigDecimal","BigDecimal.html#method-i-_dump","(p1 = v1)","<p>Method used to provide marshalling support.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">inf</span> = <span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;Infinity&#39;</span>)\n  <span class=\"ruby-comment\">#=&gt; Infinity</span>\n<span class=\"ruby-constant\">BigDecimal</span>.<span class=\"ruby-identifier\">_load</span>(<span class=\"ruby-identifier\">inf</span>.<span class=\"ruby-identifier\">_dump</span>) <span class=\"ruby-operator\">...</span>\n</pre>\n"],["_load","BigDecimal","BigDecimal.html#method-c-_load","(p1)","<p>Internal method used to provide marshalling support. See the Marshal module.\n"],["abs","BigDecimal","BigDecimal.html#method-i-abs","()","<p>Returns the absolute value, as a BigDecimal.\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;5&#39;</span>).<span class=\"ruby-identifier\">abs</span>  <span class=\"ruby-comment\">#=&gt; 0.5e1</span>\n<span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;-3&#39;</span>).<span class=\"ruby-identifier\">abs</span> <span class=\"ruby-comment\">#=&gt; 0.3e1</span>\n</pre>\n"],["add","BigDecimal","BigDecimal.html#method-i-add","(p1, p2)","<p>Add the specified value.\n<p>e.g.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span>.<span class=\"ruby-identifier\">add</span>(<span class=\"ruby-identifier\">b</span>,<span class=\"ruby-identifier\">n</span>)\n<span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span> <span class=\"ruby-operator\">+</span> <span class=\"ruby-identifier\">b</span>\n</pre>\n"],["atan","BigMath","BigMath.html#method-i-atan","(x, prec)","<p>Computes the arctangent of <code>decimal</code> to the specified number of digits of precision, <code>numeric</code>.\n<p>If <code>decimal</code> …\n"],["ceil","BigDecimal","BigDecimal.html#method-i-ceil","(p1 = v1)","<p>Return the smallest integer greater than or equal to the value, as a BigDecimal.\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;3.14159&#39;</span>).<span class=\"ruby-identifier\">ceil</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["clone","BigDecimal","BigDecimal.html#method-i-clone","()",""],["coerce","BigDecimal","BigDecimal.html#method-i-coerce","(p1)","<p>The coerce method provides support for Ruby type coercion. It is not enabled by default.\n<p>This means that …\n"],["cos","BigMath","BigMath.html#method-i-cos","(x, prec)","<p>Computes the cosine of <code>decimal</code> to the specified number of digits of precision, <code>numeric</code>.\n<p>If <code>decimal</code> is …\n"],["dfdxi","Jacobian","Jacobian.html#method-i-dfdxi","(f,fx,x,i)","<p>Computes the derivative of f at x. fx is the value of f at x.\n"],["div","BigDecimal","BigDecimal.html#method-i-div","(p1, p2 = v2)","<p>Divide by the specified value.\n<p>digits &mdash; If specified and less than the number of significant digits of the …\n"],["divmod","BigDecimal","BigDecimal.html#method-i-divmod","(p1)","<p>Divides by the specified value, and returns the quotient and modulus as BigDecimal numbers. The quotient …\n"],["double_fig","BigDecimal","BigDecimal.html#method-c-double_fig","()","<p>The BigDecimal.double_fig class method returns the number of digits a Float number is allowed to have. …\n"],["dup","BigDecimal","BigDecimal.html#method-i-dup","()",""],["eql?","BigDecimal","BigDecimal.html#method-i-eql-3F","(p1)","<p>Tests for value equality; returns true if the values are equal.\n<p>The == and === operators and the eql? …\n"],["exp","BigMath","BigMath.html#method-c-exp","(p1, p2)","<p>Computes the value of e (the base of natural logarithms) raised to the power of <code>decimal</code>, to the specified …\n"],["exponent","BigDecimal","BigDecimal.html#method-i-exponent","()","<p>Returns the exponent of the BigDecimal number, as an Integer.\n<p>If the number can be represented as 0.xxxxxx …\n"],["finite?","BigDecimal","BigDecimal.html#method-i-finite-3F","()","<p>Returns True if the value is finite (not NaN or infinite).\n"],["fix","BigDecimal","BigDecimal.html#method-i-fix","()","<p>Return the integer part of the number, as a BigDecimal.\n"],["floor","BigDecimal","BigDecimal.html#method-i-floor","(p1 = v1)","<p>Return the largest integer less than or equal to the value, as a BigDecimal.\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;3.14159&#39;</span>).<span class=\"ruby-identifier\">floor</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["frac","BigDecimal","BigDecimal.html#method-i-frac","()","<p>Return the fractional part of the number, as a BigDecimal.\n"],["hash","BigDecimal","BigDecimal.html#method-i-hash","()","<p>Creates a hash for this BigDecimal.\n<p>Two BigDecimals with equal sign, fractional part and exponent have …\n"],["infinite?","BigDecimal","BigDecimal.html#method-i-infinite-3F","()","<p>Returns nil, -1, or +1 depending on whether the value is finite, -Infinity, or +Infinity.\n"],["inspect","BigDecimal","BigDecimal.html#method-i-inspect","()","<p>Returns a string representation of self.\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&quot;1234.5678&quot;</span>).<span class=\"ruby-identifier\">inspect</span>\n  <span class=\"ruby-comment\">#=&gt; &quot;0.12345678e4&quot;</span>\n</pre>\n"],["interpret_loosely","BigDecimal","BigDecimal.html#method-c-interpret_loosely","(p1)",""],["isEqual","Jacobian","Jacobian.html#method-i-isEqual","(a,b,zero=0.0,e=1.0e-8)","<p>Determines the equality of two numbers by comparing to zero, or using the epsilon value\n"],["jacobian","Jacobian","Jacobian.html#method-i-jacobian","(f,fx,x)","<p>Computes the Jacobian of f at x. fx is the value of f at x.\n"],["limit","BigDecimal","BigDecimal.html#method-c-limit","(p1 = v1)","<p>Limit the number of significant digits in newly created BigDecimal numbers to the specified value. Rounding …\n"],["log","BigMath","BigMath.html#method-c-log","(p1, p2)","<p>Computes the natural logarithm of <code>decimal</code> to the specified number of digits of precision, <code>numeric</code>.\n<p>If …\n"],["ludecomp","LUSolve","LUSolve.html#method-i-ludecomp","(a,n,zero=0,one=1)","<p>Performs LU decomposition of the n by n matrix a.\n"],["lusolve","LUSolve","LUSolve.html#method-i-lusolve","(a,b,ps,zero=0.0)","<p>Solves a*x = b for x, using LU decomposition.\n<p>a is a matrix, b is a constant vector, x is the solution …\n"],["mode","BigDecimal","BigDecimal.html#method-c-mode","(p1, p2 = v2)","<p>Controls handling of arithmetic exceptions and rounding. If no value is supplied, the current value is …\n"],["modulo","BigDecimal","BigDecimal.html#method-i-modulo","(p1)","<p>Returns the modulus from dividing by b.\n<p>See BigDecimal#divmod.\n"],["mult","BigDecimal","BigDecimal.html#method-i-mult","(p1, p2)","<p>Multiply by the specified value.\n<p>e.g.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span>.<span class=\"ruby-identifier\">mult</span>(<span class=\"ruby-identifier\">b</span>,<span class=\"ruby-identifier\">n</span>)\n<span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span> <span class=\"ruby-operator\">*</span> <span class=\"ruby-identifier\">b</span>\n</pre>\n"],["nan?","BigDecimal","BigDecimal.html#method-i-nan-3F","()","<p>Returns True if the value is Not a Number.\n"],["nlsolve","Newton","Newton.html#method-i-nlsolve","(f,x)","<p>See also Newton\n"],["nonzero?","BigDecimal","BigDecimal.html#method-i-nonzero-3F","()","<p>Returns self if the value is non-zero, nil otherwise.\n"],["power","BigDecimal","BigDecimal.html#method-i-power","(p1, p2 = v2)","<p>Returns the value raised to the power of n.\n<p>Note that n must be an Integer.\n<p>Also available as the operator …\n"],["precs","BigDecimal","BigDecimal.html#method-i-precs","()","<p>Returns an Array of two Integer values.\n<p>The first value is the current number of significant digits in …\n"],["quo","BigDecimal","BigDecimal.html#method-i-quo","(p1)","<p>Divide by the specified value.\n<p>See BigDecimal#div.\n"],["remainder","BigDecimal","BigDecimal.html#method-i-remainder","(p1)","<p>Returns the remainder from dividing by the value.\n<p>x.remainder(y) means x-y*(x/y).truncate\n"],["round","BigDecimal","BigDecimal.html#method-i-round","(p1 = v1, p2 = v2)","<p>Round to the nearest integer (by default), returning the result as a BigDecimal if n is specified, or …\n"],["save_exception_mode","BigDecimal","BigDecimal.html#method-c-save_exception_mode","()","<p>Execute the provided block, but preserve the exception mode\n\n<pre>BigDecimal.save_exception_mode do\n  BigDecimal.mode(BigDecimal::EXCEPTION_OVERFLOW, ...</pre>\n"],["save_limit","BigDecimal","BigDecimal.html#method-c-save_limit","()","<p>Execute the provided block, but preserve the precision limit\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">BigDecimal</span>.<span class=\"ruby-identifier\">limit</span>(<span class=\"ruby-value\">100</span>)\n<span class=\"ruby-identifier\">puts</span> <span class=\"ruby-constant\">BigDecimal</span>.<span class=\"ruby-identifier\">limit</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["save_rounding_mode","BigDecimal","BigDecimal.html#method-c-save_rounding_mode","()","<p>Execute the provided block, but preserve the rounding mode\n\n<pre>BigDecimal.save_rounding_mode do\n  BigDecimal.mode(BigDecimal::ROUND_MODE, ...</pre>\n"],["sign","BigDecimal","BigDecimal.html#method-i-sign","()","<p>Returns the sign of the value.\n<p>Returns a positive value if &gt; 0, a negative value if &lt; 0, and a zero …\n"],["sin","BigMath","BigMath.html#method-i-sin","(x, prec)","<p>Computes the sine of <code>decimal</code> to the specified number of digits of precision, <code>numeric</code>.\n<p>If <code>decimal</code> is Infinity …\n"],["split","BigDecimal","BigDecimal.html#method-i-split","()","<p>Splits a BigDecimal number into four parts, returned as an array of values.\n<p>The first value represents …\n"],["sqrt","BigDecimal","BigDecimal.html#method-i-sqrt","(p1)","<p>Returns the square root of the value.\n<p>Result has at least n significant digits.\n"],["sqrt","BigMath","BigMath.html#method-i-sqrt","(x, prec)","<p>Computes the square root of <code>decimal</code> to the specified number of digits of precision, <code>numeric</code>.\n\n<pre>BigMath.sqrt(BigDecimal(&#39;2&#39;), ...</pre>\n"],["sub","BigDecimal","BigDecimal.html#method-i-sub","(p1, p2)","<p>Subtract the specified value.\n<p>e.g.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">c</span> = <span class=\"ruby-identifier\">a</span>.<span class=\"ruby-identifier\">sub</span>(<span class=\"ruby-identifier\">b</span>,<span class=\"ruby-identifier\">n</span>)\n</pre>\n"],["to_d","BigDecimal","BigDecimal.html#method-i-to_d","()","<p>Returns self.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;bigdecimal/util&#39;</span>\n\n<span class=\"ruby-identifier\">d</span> = <span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&quot;3.14&quot;</span>)\n<span class=\"ruby-identifier\">d</span>.<span class=\"ruby-identifier\">to_d</span>                       <span class=\"ruby-comment\"># =&gt; 0.314e1</span>\n</pre>\n"],["to_d","Float","Float.html#method-i-to_d","(precision=Float::DIG)","<p>Returns the value of <code>float</code> as a BigDecimal. The <code>precision</code> parameter is used to determine the number of …\n"],["to_d","Integer","Integer.html#method-i-to_d","()","<p>Returns the value of <code>int</code> as a BigDecimal.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;bigdecimal&#39;</span>\n<span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;bigdecimal/util&#39;</span>\n\n<span class=\"ruby-value\">42</span>.<span class=\"ruby-identifier\">to_d</span>   <span class=\"ruby-comment\"># ...</span>\n</pre>\n"],["to_d","NilClass","NilClass.html#method-i-to_d","()","<p>Returns nil represented as a BigDecimal.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;bigdecimal&#39;</span>\n<span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;bigdecimal/util&#39;</span>\n\n<span class=\"ruby-keyword\">nil</span>.<span class=\"ruby-identifier\">to_d</span>   <span class=\"ruby-comment\"># ...</span>\n</pre>\n"],["to_d","Rational","Rational.html#method-i-to_d","(precision)","<p>Returns the value as a BigDecimal.\n<p>The required <code>precision</code> parameter is used to determine the number of …\n"],["to_d","String","String.html#method-i-to_d","()","<p>Returns the result of interpreting leading characters in <code>str</code> as a BigDecimal.\n\n<pre class=\"ruby\"><span class=\"ruby-identifier\">require</span> <span class=\"ruby-string\">&#39;bigdecimal&#39;</span>\n<span class=\"ruby-identifier\">require</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["to_digits","BigDecimal","BigDecimal.html#method-i-to_digits","()","<p>Converts a BigDecimal to a String of the form “nnnnnn.mmm”. This method is deprecated; use …\n"],["to_f","BigDecimal","BigDecimal.html#method-i-to_f","()","<p>Returns a new Float object having approximately the same value as the BigDecimal number. Normal accuracy …\n"],["to_i","BigDecimal","BigDecimal.html#method-i-to_i","()","<p>Returns the value as an Integer.\n<p>If the BigDecimal is infinity or NaN, raises FloatDomainError.\n"],["to_int","BigDecimal","BigDecimal.html#method-i-to_int","()","<p>Returns the value as an Integer.\n<p>If the BigDecimal is infinity or NaN, raises FloatDomainError.\n"],["to_r","BigDecimal","BigDecimal.html#method-i-to_r","()","<p>Converts a BigDecimal to a Rational.\n"],["to_s","BigDecimal","BigDecimal.html#method-i-to_s","(p1 = v1)","<p>Converts the value to a string.\n<p>The default format looks like  0.xxxxEnn.\n<p>The optional parameter s consists …\n"],["truncate","BigDecimal","BigDecimal.html#method-i-truncate","(p1 = v1)","<p>Truncate to the nearest integer (by default), returning the result as a BigDecimal.\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">BigDecimal</span>(<span class=\"ruby-string\">&#39;3.14159&#39;</span>).<span class=\"ruby-identifier\">truncate</span> <span class=\"ruby-operator\">...</span>\n</pre>\n"],["zero?","BigDecimal","BigDecimal.html#method-i-zero-3F","()","<p>Returns True if the value is zero.\n"]]}}