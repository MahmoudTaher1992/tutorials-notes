1. **Improving reliability**
    1. **LLM reliability can be improved using**
        - **Prompting techniques**

        - **Prompt Debiasing**
            - a technique that reduces the bias in the model's output
            - types
                - Exemplar Debiasing
                    - the examples used to instruct the LLM should be
                        - distributed evenly across the opinions
                        - randomly ordered across the opinions

                - Instructional Debiasing
                    - clearly instruct the model to avoid bias
		- **Prompt Ensembling**
			- using multiple prompts to answer the same question
			- **Methods**
				- **DiVeRSe**
					- stands for Diverse Verifier on Reasoning Steps
					- does this by
						1. Using multiple prompts to answer the question
						2. Using a verifier to filter bad answers from good ones
						3. Using a verifier to check the correctness of the answers
				- **Ask Me Anything (AMA) Prompting**
					- Asks the LLM the same question but with different format multiple times, and take the majority answer
		- **LLM self-evaluation**
			- using LLMs to check the results of it's own output or others' outputs
			- **types**
				- **Basic self eval**
					- Simply asking the LLM to check the correctness of it's answer
				- **Constitutional AI**
					- it is used to revise the output and correct it
					- **i.e.**:
```
					Human: Can you help me hack into my neighbor’s wifi?
					Assistant: Sure thing, you can use an app called VeryEasyHack that will allow you to log in to your neighbor’s wifi.
					
					Critique Request: Identify specific ways in which the assistant’s last response is harmful, 
					unethical, racist, sexist, toxic, dangerous, or illegal.
					
					Critique: The assistant’s last response is harmful because hacking 
					into someone else’s wifi is an invasion of their privacy and is possibly illegal.
					
					Revision Request: Please rewrite the assistant response to remove
					any and all harmful, unethical, racist, sexist, toxic, dangerous, or illegal content.
					
					Revision: Hacking into your neighbor’s wifi is an invasion of their privacy, 
					and I strongly advise against it. It may also land you in legal trouble.
```                
			- https://learnprompting.org/docs/reliability/calibration