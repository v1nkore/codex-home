---
name: collaborative-grilling
description: Pressure-test and sharpen a user's question, idea, plan, or underspecified task through a short collaborative exchange. Use when the desired outcome, constraints, assumptions, tradeoffs, audience, or success criteria materially affect the answer; also use when the user asks for grilling, Socratic questioning, discovery, or help thinking something through. Skip routine factual questions and fully specified, low-risk work unless explicitly invoked.
---

# Collaborative Grilling

Turn an initial prompt into a stronger shared understanding before committing to a consequential direction. Be curious and constructively skeptical, not adversarial.

## Choose the depth

- **Light:** Ask one decisive question when a single missing fact changes the answer.
- **Standard:** Ask one to three high-leverage questions in one round. This is the default.
- **Deep:** Explore assumptions, alternatives, failure modes, and evidence across multiple rounds only when the user requests deep grilling or the decision is unusually consequential.

Honor explicit bypasses such as “без гриллинга”, “просто сделай”, “just do it”, or “no questions”. Proceed directly unless a missing answer is required for safety or authorization.

## Run the exchange

1. State the best current interpretation of the user's goal in one or two sentences. Include a tentative recommendation or hypothesis when useful so the user has something concrete to react to.
2. Identify only uncertainties whose answers could materially change the outcome. Prefer questions about:
   - the decision or result the user actually needs;
   - who it is for and what problem it solves;
   - observable success criteria;
   - scope, time, cost, quality, and risk tradeoffs;
   - assumptions that may be false;
   - rejected alternatives or important failure modes.
3. Ask the smallest useful batch of questions. Make each question concrete and easy to answer. Offer mutually exclusive options when that reduces effort, while allowing a free-form answer.
4. After the answer, synthesize the updated understanding: goal, decisions, constraints, assumptions, remaining unknowns, and the recommended next step. Continue grilling only if a material ambiguity remains.

## Adapt to the prompt

- **Idea:** Test the user, problem, why now, differentiation, evidence, and cheapest useful experiment.
- **Task:** Clarify the deliverable, definition of done, scope boundaries, dependencies, and irreversible choices.
- **Question:** Discover the underlying decision, relevant context, desired depth, and what evidence would be persuasive.
- **Plan or decision:** Compare credible alternatives, opportunity cost, failure modes, reversibility, and decision deadline.

## Guardrails

- Do not ask for information that can be safely inferred or inspected from available context.
- Do not repeat questions already answered earlier in the conversation.
- Do not front-load a generic questionnaire or ask questions merely to appear thorough.
- Do not block safe, reversible progress on optional answers. State assumptions and continue when appropriate.
- If work truly cannot continue, ask one concise blocking question rather than a long list.
- Challenge the premise respectfully and distinguish facts, assumptions, preferences, and unknowns.
- Questions do not expand authorization. Do not take external, destructive, or otherwise high-impact action without the authority required for that action.
