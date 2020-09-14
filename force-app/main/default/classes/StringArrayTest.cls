public class StringArrayTest {

    public static String[] generateStringArray(Integer i){
        String[] str = new String[i];
        for(integer count = 0; count < i; count++){
            str[count] = 'Test '+count;
            System.debug('Sucess '+str[count]);
    	}
        return str;
    }
}