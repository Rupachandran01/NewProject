public with sharing class UpdateAssignedTaskInProgram {
    public static void updateNewTasks(List<Task_Assignment__c> taskInProgram) {
        List<Id> programIds = new List<Id>();
        for(Task_Assignment__c a :taskInProgram){
            programIds.add(a.Program__c);
        }
        List<Program_Assignment__c> queriedProgram = [SELECT Id, Program__c, Employee_Name__c, Start_Date__c
                                                            FROM Program_Assignment__c
                                                            WHERE Program__c IN :programIds];
    
        List<Employee_Program_Task__c> listOfAssignedTask = new List<Employee_Program_Task__c>();
        if(queriedProgram != null){
            for(Task_Assignment__c t : taskInProgram) {
                for(Program_Assignment__c p : queriedProgram) {
                    if(t.Program__c == p.Program__c) {
                        Employee_Program_Task__c employeeTask = new Employee_Program_Task__c();
                        employeeTask.Employee__c = p.Employee_Name__c;
                        employeeTask.Training_Task__c = t.Training_Task__c;
                        employeeTask.Program__c = p.Program__c;
                        employeeTask.Due_Date__c = (p.Start_Date__c).addDays(Integer.valueOf(t.Days_Assigned_for_Task__c));

                        listOfAssignedTask.add(employeeTask);
                       
                    }
                }
            }
            listOfAssignedTask = DuplicateCheckerForTasks.checkTasks(listOfAssignedTask);
            insert listOfAssignedTask;
        }

    }   
}
