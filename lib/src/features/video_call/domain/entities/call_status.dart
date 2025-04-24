enum CallStatus {
  idle, // Call is not in progress
  calling, // Caller is waiting for callee to respond
  ringing, // Callee is being notified of an incoming call
  accepted, // Call was accepted
  rejected, // Call was rejected
  inCall,
  ended,
}
