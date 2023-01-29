/**
 * Originally based on code from: http://www.byond.com/developer/Dajinomight/Vectors
 */

#define VECTOR_ERROR_SIZE_MISMATCH "Vector size mismatch"
#define VECTOR_ERROR_NULL "Null Vector"


/vector
	var/list/contents
	var/len

/vector/New(...)
	if(args.len > 0)
		var/firstElem = args[1]
		if (istype(firstElem , /list))
			contents = firstElem
		else if(istype(firstElem, /vector))
			Copy(firstElem)
		else
			contents = new()
			for(var/x in args)
				contents += x
		len = contents.len

/vector/proc/operator+(vector/v)
	return Add(v)

/vector/proc/operator-(vector/v)
	if(v)
		return src + (-v)
	return Negate()

/vector/proc/operator[](idx,B)
	return contents[idx]

/vector/proc/operator[]=(idx,B)
	contents[idx] = B

/vector/proc/operator*(B)
	if(isnum(B))
		return Scale(B)
	else if(istype(B, /vector))
		return Dot(B)


// Mathmatical Procs
/vector/proc/Add(vector/v)
	if(v && len == v.len )
		var/vector/rv = new(src)
		for( var/i = 1; i <= len; i++ )
			rv[i] += v[i]
		return rv
	else if( v && len != v.len )
		throw( VECTOR_ERROR_SIZE_MISMATCH )
	else
		throw( VECTOR_ERROR_NULL )

/vector/proc/Negate()
	var/vector/rv = new(src)
	for( var/i = 1; i <= len; i++ )
		rv[i] = -rv[i]
	return rv

/vector/proc/Scale(var/B)
	var/vector/rv = new(src)
	for( var/i = 1; i <= len; i++ )
		rv[i] = rv[i] * B
	return rv

/vector/proc/Dot( vector/v )
	var/rv = 0
	if(v && len == v.len )
		for( var/i = 1; i <= len; i++ )
			rv += (src[i] * v[i])
		return rv
	else if( v && len != v.len )
		throw( VECTOR_ERROR_SIZE_MISMATCH )
	else
		throw( VECTOR_ERROR_NULL )

/vector/proc/Normalize()
	return Scale( 1.0/Magnitude() )

/vector/proc/SqrMagnitude()
	return ( src * src )

/vector/proc/Magnitude()
	return sqrt( src * src )


// Helper Procs
/vector/proc/Copy( vector/v )
	contents = new()
	if( !v ) return
	for(var/x in v.contents)
		contents += x

/vector/proc/ToString()
	if( IsScalar() )
		return "[contents[1]]"
	return "< [contents.Join(", ")] >"
/vector/proc/IsScalar()
	return len == 1
