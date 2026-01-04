# Observability Standard

## Required Signals
- Structured logs for all services and pipelines.
- Metrics for request volume, latency, and error rates.
- Traces for user-facing requests when applicable.

## Logging
- Logs must be JSON and include request IDs and correlation IDs.
- Errors must include actionable context and stack traces.

## Alerts
- Alerts should map to customer impact and on-call ownership.
- Define at least one SLO per critical service.
