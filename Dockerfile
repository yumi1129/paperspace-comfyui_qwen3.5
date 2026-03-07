# 1. ベースとなるNVIDIAのCUDA環境
FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

# 2. 必要なシステムツール（今回エラーを防ぐためのcmakeやninja）を導入
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    git python3 python3-pip python3-venv cmake ninja-build build-essential wget

# 3. PyTorchのインストール
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# 4. ComfyUI本体のインストール
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI
RUN pip3 install -r /ComfyUI/requirements.txt

# 5. Qwen対応のカスタムノード（Prompt Manager）のインストール
RUN git clone https://github.com/FranckyB/ComfyUI-Prompt-Manager.git /ComfyUI/custom_nodes/ComfyUI-Prompt-Manager
RUN pip3 install -r /ComfyUI/custom_nodes/ComfyUI-Prompt-Manager/requirements.txt

# 6. 【重要】悩みの種だったエンジンをここで確実にビルド！
ENV CMAKE_ARGS="-DGGML_CUDA=on"
RUN pip3 install llama-cpp-python>=0.3.17 --upgrade --no-cache-dir

WORKDIR /ComfyUI
