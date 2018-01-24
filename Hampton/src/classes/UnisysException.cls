public with sharing class UnisysException extends Exception {
    public static void Raise(string aString)
    {
        throw new UnisysException(aString);
    }
    
    public static void Raise(string aString, Exception anException)
    {
        throw new UnisysException(aString, anException);
    }
    
    public static void Raise(string format, object arg1)
    {
        Raise(String.Format(format, new string[] { '' + arg1 }));
    }
    
    public static void Raise(string format, object arg1, object arg2)
    {
    Raise(String.Format(format, new string[] { '' + arg1, '' + arg2 }));
    }
    
    public static void Raise(string format, object arg1, object arg2, object arg3)
    {
        Raise(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3 }));
    }
    
    public static void Raise(string format, object arg1, object arg2, object arg3, object arg4)
    {
        Raise(String.Format(format, new string[] { '' + arg1, '' + arg2, '' + arg3, '' + arg4 }));
    }
}