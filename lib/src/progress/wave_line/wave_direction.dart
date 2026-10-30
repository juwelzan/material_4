/// Trajectory direction for wave oscillation and phase propagation in [Material4ProgressBar].
enum WaveDirection {
  /// Wave crests propagate from left to right (forward along progression).
  forward,

  /// Wave crests propagate from right to left (backwards against progression).
  reverse,

  /// Wave oscillates back and forth in a continuous ping-pong rebound cycle.
  pingPong,

  /// Multi-layer waves alternate in opposing directions across adjacent strands.
  alternating,
}
