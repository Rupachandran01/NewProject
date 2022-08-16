public with sharing class DuplicateCheckerForTasks {
    public static List<Employee_Program_Task__c> checkTasks(List<Employee_Program_Task__c> employeeTask) {
        set<Id> taskSet = new Set<Id>();
        set<Id> employeeSet = new Set<Id>();
        for(Employee_Program_Task__c e : employeeTask) {
            taskSet.add(e.Training_Task__c);
            employeeSet.add(e.Employee__c);
        }
        List<Employee_Program_Task__c> queryAssignedTasks = [SELECT Training_Task__c, Employee__c
                                                        FROM Employee_Program_Task__c
                                                        WHERE Training_Task__c IN :taskSet OR Employee__c IN :employeeSet];
        Set<Id> queriedTaskSet = new Set<Id>();
        Set<Id> queriedEmployeeSet = new Set<Id>();
        for(Employee_Program_Task__c e : queryAssignedTasks){
            queriedTaskSet.add(e.Training_Task__c);
            queriedEmployeeSet.add(e.Employee__c);
        }
        List<Employee_Program_Task__c> uniqueList = new List<Employee_Program_Task__c>();
        for(Employee_Program_Task__c et : employeeTask) {
            if(queriedTaskSet.contains(et.Training_Task__c) && queriedEmployeeSet.contains(et.Employee__c)) {
                et.addError('This Task already Exists!');
            }
            else{
                uniqueList.add(et);
            }
        }
        return uniqueList;
    }
}
