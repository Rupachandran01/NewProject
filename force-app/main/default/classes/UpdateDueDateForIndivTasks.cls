public with sharing class UpdateDueDateForIndivTasks {
    public UpdateDueDateForIndivTasks() {

    }
    public static void updateDueDates(List<Employee_Program_Task__c> employeetasks) {
        employeetasks = DuplicatecheckerForTasks.checkTasks(employeetasks);
        List<Id> tasklist = new List<Id>();
        for(Employee_Program_Task__c et : employeetasks) {
            if(et.Program__c == null) {
                tasklist.add(et.Training_Task__c);
            }
        }
        if(tasklist.size() >0) {
            Map<Id,Training_Task__c> mapOfTask = new Map<Id, Training_Task__c>([SELECT Name, No_of_Days_to_Complete__c
                                                                FROM Training_Task__c
                                                                WHERE Id IN :tasklist]);
            List<Employee_Program_Task__c> listOfAssignedTask = new List<Employee_Program_Task__c>();
            for(Employee_Program_Task__c empTask : employeetasks) {
            Decimal numberofDays = mapOfTask.get(empTask.Training_Task__c).No_of_Days_to_Complete__c;
            empTask.Due_Date__c = empTask.Start_Date__c.addDays(numberofDays.intValue());
            }
        }
    }
}

