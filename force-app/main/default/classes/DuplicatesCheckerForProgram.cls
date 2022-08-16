public with sharing class DuplicatesCheckerForProgram {

    public static Boolean checkPrograms(List<Program_Assignment__c> assignedPrograms) {
        Set<Id> programSet = new Set<Id>();
        Set<Id> employeeSet = new Set<Id>();
        for(Program_Assignment__c a :assignedPrograms)
        {
            programSet.add(a.Program__c);
            employeeSet.add(a.Employee_Name__c);
        }
        List<Program_Assignment__c> queryAssignedProgram = [SELECT Program__c, Employee_Name__c
                                                                FROM Program_Assignment__c
                                                                WHERE Program__c IN :programSet OR Employee_Name__c IN :employeeSet];
        Set<Id> queriedProgramSet = new Set<Id>();
        Set<Id> queriedEmployeeSet = new Set<Id>();
        for(Program_Assignment__c a :queryAssignedProgram)
        {
            queriedProgramSet.add(a.Program__c);
            queriedEmployeeSet.add(a.Employee_Name__c);
        }
        for(Program_Assignment__c ap : assignedPrograms) {
            if(queriedProgramSet.contains(ap.Program__c) && queriedEmployeeSet.contains(ap.Employee_Name__c)) {
                ap.addError('This Program already Exists!');
                return false;
            }
        }
        return true;
    }
}