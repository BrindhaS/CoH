public with sharing class FuzzySearch
{
    public static Map<Decimal, Sobject[]> Score(Sobject[] recs, String field, String val)
    {
        String s1 = val.toUpperCase().remove('.').remove(',').remove('&').remove('(').remove(')').remove('\'').remove('-').remove('%');
        
        String[] s1Scrambled = new String[]{};
        String[] s1s = s1.split(' ');
        for (Integer i=0; i<s1s.size(); i++)
        {
            for (Integer j=0; j<s1s.size(); j++)
            {
                String[] cloned = s1s.clone();
                String temp = cloned[i];
                cloned[i] = cloned[j];
                cloned[j] = temp;
                
                s1Scrambled.add(String.join(cloned, ' '));
            }
        }
        
        Map<Decimal, Sobject[]> scoredRecs = new Map<Decimal, Sobject[]>();
        for (Sobject c : recs)
        {
            String s2 = ((String)c.get(field)).toUpperCase().remove('.').remove(',').remove('&').remove('(').remove(')').remove('\'').remove('-').remove('%');
            
            Decimal bestScore = 0;
            for (String scram : s1Scrambled)
            {
                Decimal score = 1.0 - ((Decimal)scram.getLevenshteinDistance(s2) / Math.Max(scram.Length(), s2.Length()));
                if (score > bestScore) bestScore = score;
            }
            
            if (scoredRecs.containsKey(bestScore)) scoredRecs.get(bestScore).add(c);
            else scoredRecs.put(bestScore, new Sobject[]{c});
        }
        
        return scoredRecs;
    }
    
    public static Decimal Compare(String s1, String s2, Boolean useScramble)
    {
        s1 = s1.toUpperCase().remove('.').remove(',').remove('&').remove('(').remove(')').remove('\'').remove('-').remove('%');
        s2 = s2.toUpperCase().remove('.').remove(',').remove('&').remove('(').remove(')').remove('\'').remove('-').remove('%');
        
        if (useScramble)
        {
            Decimal bestScore = 0;
            String[] s1s = s1.split(' ');
            for (Integer i=0; i<s1s.size(); i++)
            {
                for (Integer j=0; j<s1s.size(); j++)
                {
                    String[] cloned = s1s.clone();
                    String temp = cloned[i];
                    cloned[i] = cloned[j];
                    cloned[j] = temp;
                    
                    Decimal score = getScore(String.join(cloned, ' '), s2);
                    if (score > bestScore) bestScore = score;
                }
            }
            
            return bestScore;
        }
        else
        {
            return getScore(s1, s2);
        }
    }
    
    public static List<string> Search(string word, List<string> wordList, Decimal fuzzyness)
    {
        List<string> foundWords = new List<string>();
    
        for (string s : wordList)
        {
            Decimal score = Compare(word, s, false);
            if (score > fuzzyness) foundWords.Add(s);
        }
        return foundWords;
    }
    
    private static Decimal getScore(String s1, String s2)
    {
        return 1.0 - ((Decimal)s1.getLevenshteinDistance(s2) / Math.Max(s1.Length(), s2.Length()));
    }
    
    @isTest
    private static void testSearch()
    {
        string s = 'Maxwell Giger';
        string[] words = new string[]{'maximus johnson', 'alen giggs', 'max giger', 'Maximilian Giger', 'al pacino maxwell', 'dude in black', 'giger max', 'maxis of gigity', 'Max Giger', 'Maxwell  Gigz'};
        string[] res = FuzzySearch.Search(s,words,0.6);
        Decimal score = FuzzySearch.Compare(s, words[0], true);
    }
}