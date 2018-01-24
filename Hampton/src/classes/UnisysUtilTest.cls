@isTest
private class UnisysUtilTest {
   
  static testMethod void testDecimalValueOf(){
    system.assertEquals(1.234,UnisysUtil.DecimalValueOf('$1one.2two#3$4&*',0));
    system.assertEquals(1000.00,UnisysUtil.DecimalValueOf('$1,000.00',null));
    system.assertEquals(-1,UnisysUtil.DecimalValueOf('1.23.45',-1.0));
    system.assertEquals(0, UnisysUtil.DecimalValueOf(null, 0));
  }

  static testMethod void testIntegerValueOf(){
    system.assertEquals(1,UnisysUtil.integerValueOf('$1one.2two#3$4&*',0));
    system.assertEquals(1000.00,UnisysUtil.integerValueOf('$1,000.00',-1));
    system.assertEquals(null,UnisysUtil.integerValueOf('1.23.45',null));
    system.assertEquals(-1,UnisysUtil.integerValueOf('-1',0));
  }

    static testMethod void testStringJoin()
    {
      List<string> wordList = new List<string> { 'two', 'three', 'four' };
      
      System.assertEquals('two,three,four', UnisysUtil.Join(wordList, ','));
      
      set<string> wordSet = new set<string>(wordList);
      string result = UnisysUtil.join(wordSet, ',');      
    }
    
    static testMethod void testStringReplace() {
      System.assertEquals('here and there', UnisysUtil.TypeToLabel('here_and_there__c'));
    }
    
    static testMethod void testStringSplits()
    {
      List<String> stringList = UnisysUtil.Trim('one, two, three'.split(','));
      System.assertEquals('one', stringList[0]);
      System.assertEquals('two', stringList[1]);
      System.assertEquals('three', stringList[2]);
      
      stringList = UnisysUtil.Trim(' '.trim().split(','));
      System.assertEquals(0, stringList.size());     
    }
    
    static testMethod void testTitleFromString()
    {
      System.assertEquals('one', UnisysUtil.SubjectFromString('one. two. three.  four.'));
      System.assertEquals('one two', UnisysUtil.SubjectFromString('one two.\nthree four\n'));
    }
    
    static testMethod void testSplitExpressions()
    {
      System.assertEquals('one', UnisysUtil.SubjectFromString('one.two.three'));
      System.assertEquals('one', UnisysUtil.SubjectFromString('one.\n\rtwo.\n\rthree.\r'));
      System.assertEquals('one', UnisysUtil.SubjectFromString('one.\n\rtwo.\n\rthree.\r'));
      System.assertEquals('one', UnisysUtil.SubjectFromString('one?  two.\n\rthree.\r'));
      System.assertEquals('xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0', UnisysUtil.SubjectFromString('xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0xxxxxxxxx0yyyyyy'));
    }
    
    static testMethod void testFormatListForQuery(){
      List<String> aList = new List<String>{'red','white','blue'};
      
      String formattedString = UnisysUtil.formatListForQuery(aList);
      
      //system.assertEquals('(\'red\',\'white\',\'blue\')',formattedString);
      
      formattedString = UnisysUtil.formatListForQuery(new string[] { 'null' });
      system.assertEquals('( null )', formattedString);
      
    }
    
    static testMethod void testDateString()
    {
      system.assertEquals('2012-04-15', UnisysUtil.DateString(Date.newInstance(2012, 4, 15)));
    }
    
    static testMethod void testRightString()
    {
      system.assertEquals('789', UnisysUtil.right('6789', 3));
    }
    
    static testMethod void testDatesInSets()
    {
      map<date, string> dateMap = new map<date, string>();
      
      dateMap.put(Date.today(), 'today');
      dateMap.put(Date.today().addDays(1), 'tomorrow');
      dateMap.put(Date.today().addDays(-1), 'yesterday');
      
      system.assertEquals('today', dateMap.get(Date.today()));
      system.assertEquals('yesterday', dateMap.get(Date.today().addDays(-1)));
      system.assertEquals('tomorrow', dateMap.get(Date.today().addDays(1)));
    }
    
    static testMethod void chatterTest()
    {
      UnisysUtil.ChatterText(UserInfo.GetUserId(), 'Chatter title', 'Chatter body');
    }
    
    static testMethod void listFormatTest()
    {
    list<string> aList = new string[] { 'one', 'two', 'three', 'null' };
      string listAnswer = UnisysUtil.FormatListForQuery(aList);
      string setAnswer = UnisysUtil.FormatListForQuery(new set<string>(aList));
      system.assertEquals(listAnswer, setAnswer);
      system.assertEquals(true, UnisysUtil.ListIncludesNulls(aList));
      system.assertEquals(false, UnisysUtil.ListIncludesNulls(new string[] { 'a', 'b', 'c' } ));
    }
    
    static testMethod void fieldTest()
    {
    string aString = UnisysUtil.truncateStringAtFieldLength('000000000x000000000x000000000x000000000x000000000x000000000x000000000x000000000x000', User.Username);
    system.assertNotEquals(null, aString);
    }
    
    static testMethod void localUrlTest()
    {
      system.assert(UnisysUtil.LocalUrlFor('home').endsWith('/home'));
    }    
}