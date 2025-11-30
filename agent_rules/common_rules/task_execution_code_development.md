# Task Execution (Code Development) Procedure

When receives a user's code development request, it follows these steps sequentially, obtaining user confirmation after completing each step.

## Step 1: Requirements Analysis and Information Gathering
1. **Understanding the Final Objective**: Clearly identify the ultimate goal the user wants to achieve.
2. **Identifying and Requesting Necessary Information**: Ask the user in detail for information needed to create a concrete work plan (e.g., related files, existing logic, constraints, etc.).
3. **Information Review and Additional Inquiries**: Analyze the provided information and repeatedly ask questions until sufficient information is secured if there are unclear or missing parts. *Avoid proceeding with work based on assumptions.*

## Step 2: Macro-level Work Plan Development and Review
1. **Presenting Draft Work Plan**: Based on the collected information, establish and present a step-by-step plan (High-level plan) for the entire work to the user.
2. **Incorporating Feedback and Finalizing Plan**: Actively incorporate user feedback to modify the work plan and ultimately obtain user agreement on the plan.

## Step 3: Step-by-step Detailed Work Progress and Review
1. **Presenting Detailed Work Plans**: Propose specific work content (e.g., code change scope, function signatures, data structures, etc.) to the user for performing each step of the confirmed macro-level plan.
2. **Feedback-based Modifications**: Reflect user feedback on the presented detailed work content and make modifications.
3. **Code Modification Proposal and Approval**: Present actual code modification proposals according to the agreed detailed plan and apply them after receiving user approval. (Note: Code modifications use the `edit_file` tool and do not directly output code.)

## Step 4: Final Review and Completion
1. **Overall Work Content Review**: After all steps are completed, present the entire work deliverables (code changes, impact scope, etc.) to the user once more and request review.
2. **Incorporating Final Feedback**: If there is final feedback from the user, reflect it and proceed with necessary modifications.
3. **Work Completion Confirmation**: Complete the work through the user's final approval.

## Core Principles and Precautions

* **User Confirmation**: After completing each major step (information gathering completion, plan establishment completion, before detailed work progress, before final completion), you must explicitly confirm the user's intention by asking something like "May I proceed to the next step?" and receive a positive response.
* **No Assumptions When Information is Insufficient**: When necessary information is lacking or ambiguous during work progress, do not proceed with arbitrary assumptions but always request additional clear information from the user.
* **Proactive Communication**: Actively ask questions and seek feedback to accurately understand the user's intentions and create optimal deliverables.