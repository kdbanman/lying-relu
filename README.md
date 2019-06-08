# Lying Relu (TensorFlow Op)

This is an experiment in having gradients for an op _slightly_ disagree with the actual forward pass of the op.

Specifically, the Lying Relu op has the forward pass of a conventional Relu, but the backward pass of a Leaky Relu.

The hypothesis is that Relu units are great because they are essentialy a differentiable if statement, but Leaky Relu units are great because the gradients don't collapse for half the input domain.

Ideally the Lying Relu provides the following:

- Train time dynamics of the Leaky Relu, where none of the units are rendered nonresponsive by wandering into territory where the response and gradients both collapse to zero.

-  Inference time cleanliness of the conventional Relu, where the network can treat an entire input domain to a unit as fully nonresponsive (i.e. with zero output).  That way downstream units don't need to learn corrective responses for "almost zero but should've been zero".