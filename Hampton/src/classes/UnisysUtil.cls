public with sharing class UnisysUtil {
  public static void ChatterText(ID id, String title, String body)
    {
      ChatterId(id, 'TextPost', title, body, null);
    }
    
  public static void ChatterLink(ID id, string title, string body, string url)
  {
    ChatterId(id, 'LinkPost', title, body, url);  
  }

  public static void ChatterId(ID id, string postType, string title, string body, string url)
  {
    FeedItem aFeedPost = new FeedItem();  
    aFeedPost.parentId = id;
    aFeedPost.Type = postType;
    aFeedPost.Title = title;
    aFeedPost.Body = body;
    aFeedPost.linkUrl= url;
    System.debug('This is the chatter getting created.');
    insert aFeedPost;    
  }
  
  //
    // you may wonder why we need this if we can just return '' + aDate.  Well,
    // we can't.  Dates constructed with NewInstance() include GMT offset data
    // that are included with we '' + them.
    //
    public static string DateString(Date aDate)
    {
      return DateTime.newInstance(aDate, Time.NewInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
    }
    
  public static Decimal DecimalValueOf(String aStringValue, Decimal errorValue){
    try{
      Decimal returnValue = Decimal.valueOf(aStringValue.replaceAll('[^-.\\d]',''));
      return returnValue;
    }
    catch(system.TypeException te){
      return errorValue;
    }    
    catch(system.NullPointerException npe){
      return errorValue;
    }    
  }
    
  public static void Follow(ID entityId)
    {
      FollowByUserId(entityId, UserInfo.getUserId());
    }  
  
  public static void FollowByUserId(ID entityId, ID userId)
    {
      try {
        EntitySubscription follow = new EntitySubscription (
              parentId = entityId,
                subscriberid = userId);

      insert follow;
    }
    catch (Exception ex) {
      // ignore
    }
    }
    
    public static String FormatListForQuery(List<String> aList)
  {
    return FormatListForQuery(alist, false);
  }
  
  public static String FormatListForQuery(Set<string> aSet)
  {
    return FormatListForQuery(new list<string>(aSet));
  }
  
  public static String FormatListForQuery(List<String> aList, boolean ignoreNulls) {
    set<string> stringSet = new set<string>(aList);
    boolean hasNull = stringSet.remove('null') || stringSet.remove('NULL');
    
    list<string> stringList = new list<string>(stringSet);
      
    String formattedString = Join(stringList, '\',\'');
    
    if (hasNull && stringList.isEmpty())
      formattedString = '( null )';
    else if (hasNull)
      formattedString = '( null, \'' + formattedString + '\' )';
    else 
      formattedString = '( \'' + formattedString + '\' )';
      
    return formattedString;
  }
  
  public static Integer IntegerValueOf(String aStringValue, Integer errorValue){
    try{
      Integer returnValue = DecimalValueOf(aStringValue,errorValue).intValue();
      return returnValue;
    }
    catch(system.NullPointerException npe){
      return errorValue;
    }    
  }
    
    public static boolean IsFieldTooLong(String aString, Schema.Sobjectfield aField)
    {
      return IsFieldTooLong(aString, aField.getDescribe().getLength());
    }
    
    public static boolean IsFieldTooLong(String aString, integer length)
    {
      return aString.length() > length;
    }
    
    public static string Join(Set<string> stringSet, string separator)
  {
    List<string> stringList = new List<string>();
    
    stringList.addAll(stringSet);
    
    return Join(stringList, separator);
  }
  
  public static String Join(List<string> stringList, string separator)
  {
    if (stringList.isEmpty())
      return '';
      
    String result = '';
    integer listSize = stringList.size();
    
    for (integer i = 0; i < listSize - 1; i++)
      result += stringList[i] + separator;
    
    return result + stringList[listSize - 1];
  }

  public static boolean ListIncludesNulls(list<string> aList)
  {
    for (string each : aList)
      if (each.toLowerCase() == 'null')
        return true;
    
    return false;
  }

  public static string LocalUrlFor(string localResourceLocation)
    {
      if (localResourceLocation.startsWith('/') == false)
        localResourceLocation = '/' + localResourceLocation;
        
      return URL.getSalesforceBaseUrl().toExternalForm() + localResourceLocation;
    }
    
    public static String Right(string aString, integer numChars)
  {
    integer length = aString.length();
    
    return aString.substring(length - numChars);
  }
  
  public static String SubjectFromString(String aString)
  {
    if (aString.trim().length() == 0)  
      return '';
      
    string sentence;
    string[] strings = aString.split('[\\.\n\r\\?\\!]');
    
    if (strings.isEmpty())
      sentence = aString.substring(0, Math.max(40, aString.length() + 1));
    else
      sentence = strings[0];
      
    return sentence.substring(0, Math.min(40, sentence.length()));
  }

  public static string TypeToLabel(String aType)
  {
    return aType.replace('__c', '').replace('_', ' ');
  }
  
  public static List<String> Trim(List<String> aStringList)
  {
    List<String> newList = new List<String>();
    
    for (String each : aStringList) {
      if (each.trim().length() > 0)
        newList.add(each.trim());
    }
      
    return newList;
  }
  
  public static string truncateStringAtFieldLength(string aString, Schema.Sobjectfield aField)
    {
      if (isFieldTooLong(aString, aField))
        return aString.substring(0, aField.getDescribe().getLength());
      
      return aString;
    }
}