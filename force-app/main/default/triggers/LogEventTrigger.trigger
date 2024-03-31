trigger LogEventTrigger on LogEvent__e (after insert) {
    LogEventHandler.logEvents(Trigger.new);
}