/*****************************************
*@Author            : Marvin Gatchalian
*@Company           : ITWorks Computer Services
*@Description       : This class mainly used for retrieving record by Id or set of Id or related object
*@Test Class        : ITWCreateOrderLineItemTest
*@Date              : N/A
*@Revision          :
*When                 Who                 What
*27-Jul-2022          Marvin Gatchalian   Created
*****************************************/

public with sharing class ITW_Randomizer {

    public class Request {
        @InvocableVariable(required=true)
        public List <Questionaire__c> listToRandom;

        @InvocableVariable
        public List <ChoicesAndAnswers__c> listCandAToRandom;

        @InvocableVariable()
        public Integer qSize;

    }

    public class ResultWrap {
        @InvocableVariable()
        public List <Questionaire__c> outPutList;

    }

    @InvocableMethod
    public static List<ResultWrap> randomize (List<Request> requestParam) {
        //final String EXPIRED = 'Expired';
        List<ResultWrap> results = new List<ResultWrap>();

        for (Request eacHReq :requestParam){
            ResultWrap resultW = new ResultWrap();
            results.add(randomizeList(eacHReq));
        }

        Return results;
        
    }

    public static ResultWrap randomizeList(Request request) {
       
        ResultWrap aResult = new ResultWrap();
        List<SObject> lst = new List<SObject>();
        List<SObject> newListQ = new List<SObject>();

        lst = (List<SObject>) request.listToRandom;
        integer currentIndex = request.qSize; 
        Questionaire__c temporaryValue;
        integer randomIndex;

        // While there remain elements to shuffle...
        while (0 != currentIndex) {
        // Pick a remaining element...
          randomIndex = integer.valueOf(Math.floor(Math.random() * lst.size()));
          currentIndex -= 1;
          // And swap it with the current element.
          //temporaryValue = lst[currentIndex];
          //lst[currentIndex] = lst[randomIndex];
          
          newListQ.add(lst[randomIndex]);
          lst.remove(randomIndex);

        }
        aResult.outPutList = newListQ;

        system.debug ('request.listToRandom >>>' + request.listToRandom);
        system.debug ('aResult.outPutList >>>' + request.listToRandom);

        return aResult;
    }
}