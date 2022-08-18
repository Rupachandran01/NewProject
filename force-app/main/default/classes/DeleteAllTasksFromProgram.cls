public with sharing class DeleteAllTasksFromProgram {
    public DeleteAllTasksFromProgram() {

    }
    public static void deleteAssignedEmployeeTask(Map<Id, Program_Assignment__c> assignedPrograms) {
        List<Employee_Program_Task__c> listofEmp =[SELECT Id
                                                    FROM Employee_Program_Task__c
                                                    WHERE  Program_Assignment__c IN :assignedPrograms.keySet()];
        delete listofEmp;
    }
}
