/*****************************************
*@Author        :Marvin Gatchalian
*@Company       :
*@Description   :
*@Test Class:   :
*@Date:N/A
*@Revision:
*When                 Who                 What
*17-Apr-2023          Marvin Gatchalian   Created
*****************************************/

public with sharing class MultipleAnswersChecker {
    
    class ConvertLeadActionException extends Exception {}

    public class ActionRequest {
        @InvocableVariable
        public String SelectedAnswers = '';

        @InvocableVariable(required=true)
        public String qId;

    }

    public class ActionResult {
        @InvocableVariable
        public Boolean isResult = false;
    }

    @InvocableMethod(label='Check Answers')
    public static List<ActionResult> CheckAnswers(List<ActionRequest> requests) {
        List<ActionResult> results = new List<ActionResult>();

        for (ActionRequest request : requests) {   //This value is always one thus dml, soql inside this loop is acceptable
          results.add(CheckSelectedAnswers(request));
        }
        return results;
    }

    public static ActionResult CheckSelectedAnswers(ActionRequest request) {

        ActionResult aResult = new ActionResult();
        List<String> cAndAIds = new List<String>();
        cAndAIds = request.SelectedAnswers.split(';');

        List<ChoicesAndAnswers__c> cAndAs = [SELECT id, isAnswer__c FROM ChoicesAndAnswers__c WHERE Id IN :cAndAIds];

        List<ChoicesAndAnswers__c> trueAnswers = [SELECT id, isAnswer__c FROM ChoicesAndAnswers__c 
                                                  WHERE isAnswer__c = true AND Question__c = :request.qId];

        aResult.isResult = true;

        for (ChoicesAndAnswers__c eachCAndA :cAndAs) {
            if (!eachCAndA.isAnswer__c) {
                aResult.isResult = false;
            }
        }
        
        if (cAndAIds.size() != trueAnswers.size()) {
            aResult.isResult = false;
        }
        
        return aResult;
    }
}