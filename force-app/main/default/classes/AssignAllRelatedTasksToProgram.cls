public with sharing class AssignAllRelatedTasksToProgram {
    public static void assignAllTasks(List<Program_Assignment__c> assignedPrograms) {
        List<Id> programIds = new List<Id>();
        for(Program_Assignment__c a :assignedPrograms)
        {
            programIds.add(a.Program__c);
        }
        List<Task_Assignment__c> taskInProgramQuery = [SELECT Id, Program__c, 	Training_Task__c, Days_Assigned_for_Task__c	
                                                            FROM Task_Assignment__c
                                                            WHERE Program__c IN :programIds];
    
        List<Employee_Program_Task__c> listOfAssignedTask = new List<Employee_Program_Task__c>();
        
        for(Program_Assignment__c p : assignedPrograms) {
            for(Task_Assignment__c t : taskInProgramQuery) {
                if(p.Program__c == t.Program__c) {
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
