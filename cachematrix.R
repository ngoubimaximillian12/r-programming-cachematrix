
# This function creates a special "matrix" object that can cache its inverse.
makeCacheMatrix <- function(x = matrix()) {
  m <- NULL  # Initialize m as NULL, which will store the inverse matrix
  
  # Function to set the value of the matrix
  set <- function(y) {
    x <<- y   # Set the matrix to x
    m <<- NULL # Reset m (inverse matrix) as NULL whenever the matrix changes
  }
  
  # Function to get the value of the matrix
  get <- function() x
  
  # Function to set the value of the inverse
  setinverse <- function(inverse) m <<- inverse
  
  # Function to get the value of the inverse
  getinverse <- function() m
  
  # Return a list of all the functions to interact with the matrix
  list(set = set, get = get, setinverse = setinverse, getinverse = getinverse)
}

# This function computes the inverse of the special "matrix" object returned by makeCacheMatrix.
# It first checks if the inverse is already cached, if so it returns it from cache.
cacheSolve <- function(x, ...) {
  # Check if the inverse is already calculated and cached
  m <- x$getinverse()
  
  if(!is.null(m)) {
    message("getting cached data")  # If cached, return the cached inverse
    return(m)
  }
  
  # If not cached, calculate the inverse and cache it
  data <- x$get()  # Get the matrix from the object
  m <- solve(data, ...)  # Compute the inverse using solve() function
  
  # Cache the computed inverse
  x$setinverse(m)
  
  m  # Return the inverse
}
