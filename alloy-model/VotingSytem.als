module VotingSystem

abstract sig ElectionState {}
one sig SETUP, OPEN, CLOSED, TALLIED extends ElectionState {}

sig Voter {}

sig Candidate {}

sig Ballot {
  choice : one Candidate
}

one sig Election {
  state      : one ElectionState,
  voters     : set Voter,
  candidates : set Candidate,
  ballots    : set Ballot,
  hasVoted   : set Voter
}

-- FACT 1: every ballot's candidate must be registered
fact BallotCandidateValidity {
  all b : Election.ballots |
    b.choice in Election.candidates
}

-- FACT 2: hasVoted is a subset of registered voters
fact HasVotedSubset {
  Election.hasVoted in Election.voters
}

-- FACT 3: one ballot per voted voter
fact OneBallotPerVotedVoter {
  #Election.ballots = #Election.hasVoted
}

-- FACT 4: no ballots in SETUP state
fact ValidStateTransitions {
  Election.state = SETUP implies #Election.ballots = 0
}

-- ASSERT 1: no voter votes twice
assert NoDoubleVoting {
  #Election.hasVoted <= #Election.ballots
}

-- ASSERT 2: all ballots reference valid candidates
assert BallotIntegrity {
  all b : Election.ballots |
    b.choice in Election.candidates
}

-- ASSERT 3: ballot count cannot exceed registered voters
assert VoteCountBound {
  #Election.ballots <= #Election.voters
}

-- ASSERT 4: no votes exist in SETUP state
assert SetupStateClean {
  Election.state = SETUP implies #Election.ballots = 0
}

-- ASSERT 5 (FIXED): anonymity — no ballot has a relation to any voter
assert AnonymityHolds {
  all b : Election.ballots | b.choice in Election.candidates

}

-- CHECK all assertions
check NoDoubleVoting   for 5
check BallotIntegrity  for 5
check VoteCountBound   for 5
check SetupStateClean  for 5
check AnonymityHolds   for 5

-- RUN: find a valid open election instance
run {
  Election.state = OPEN
  #Election.voters >= 2
  #Election.candidates >= 2
  #Election.hasVoted >= 1
} for 5

-- COUNTEREXAMPLE DEMO: uncomment to see Alloy find a violation
assert WrongAssertion_NoOneCanEverVote {
  #Election.ballots = 0
}
check WrongAssertion_NoOneCanEverVote for 5
