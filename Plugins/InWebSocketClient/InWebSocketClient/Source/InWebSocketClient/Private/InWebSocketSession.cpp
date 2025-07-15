// Fill out your copyright notice in the Description page of Project Settings.


#include "InWebSocketSession.h"
#include "IWebSocket.h"
#include "WebSocketsModule.h"
#include "InWebSocketClient.h"
#include "HttpModule.h"
#include "PlatformHttp.h"

UInWebSocketSession* UInWebSocketSession::CreateWebSocket(const FString& Url)
{
	UInWebSocketSession* ptr =  NewObject<UInWebSocketSession>();
	ptr->m_Url = Url;
	return ptr;
}

void UInWebSocketSession::Activate()
{
	UE_LOG(LogInWebSocketClientModule, Log, TEXT("UInWebSocketSession Activate url=%s"), *m_Url);
	Connect();
}

void UInWebSocketSession::Connect()
{
	if (nullptr != m_NativeSocket)
	{
		UE_LOG(LogInWebSocketClientModule, Warning,TEXT("UInWebSocketSession nullptr != m_NativeSocket "));
		return;
	}
	m_NativeSocket = FWebSocketsModule::Get().CreateWebSocket(m_Url);
	m_NativeSocket->OnConnected().AddUObject(this, &UInWebSocketSession::OnConnected);
	m_NativeSocket->OnClosed().AddUObject(this, &UInWebSocketSession::OnClosed);
	m_NativeSocket->OnMessage().AddUObject(this, &UInWebSocketSession::OnMessage);
	m_NativeSocket->OnRawMessage().AddUObject(this, &UInWebSocketSession::OnRawMessage);
	m_NativeSocket->OnConnectionError().AddUObject(this, &UInWebSocketSession::OnError);

	m_NativeSocket->Connect();
}
void UInWebSocketSession::Close()
{
	if (false == IsConnected())
	{
		m_NativeSocket = nullptr;
		SetReadyToDestroy();
		return;
	}
	m_NativeSocket->Close();
	m_NativeSocket = nullptr;
	SetReadyToDestroy();
}

void UInWebSocketSession::SendMessage(const FString& Message)
{
	if (false == IsConnected())
	{
		UE_LOG(LogInWebSocketClientModule, Error, TEXT("UInWebSocketSession IsConnected false"));
		return;
	}
	if (Message.Len() <= 0)
	{
		UE_LOG(LogInWebSocketClientModule, Error, TEXT("UInWebSocketSession SendMessage Message is empty"));
		return;
	}
	UE_LOG(LogInWebSocketClientModule, Log, TEXT("UInWebSocketSession SendMessage Message=%s"), *Message);
	m_NativeSocket->Send(Message);
}
FString UInWebSocketSession::FMD5HashString(FString AppId, FString ApiKey, FString Ts)
{
	// FString Timestamp = FString::FromInt(FDateTime::UtcNow().ToUnixTimestamp());
	FString Input = AppId + Ts;
	FString MD5Hash = FMD5::HashBytes((const uint8*)TCHAR_TO_UTF8(*Input), Input.Len());
	// 3. 计算HMAC-SHA1
	TArray<uint8> ApiKeyBytes;
	ApiKeyBytes.Append((uint8*)TCHAR_TO_UTF8(*ApiKey), ApiKey.Len());
	TArray<uint8> BaseStringBytes;
	BaseStringBytes.Append((uint8*)TCHAR_TO_UTF8(*MD5Hash), MD5Hash.Len());
	TArray<uint8> HmacResult;

	const int32 SHA1HashSize = 20; // SHA1 哈希长度是 20 字节
	HmacResult.SetNumUninitialized(SHA1HashSize);
	// 方法1：使用 FHMAC 类 (推荐)
	FSHA1::HMACBuffer(ApiKeyBytes.GetData(), ApiKeyBytes.Num(), BaseStringBytes.GetData(), BaseStringBytes.Num(), HmacResult.GetData());
	
	// 4. Base64 编码
	FString Signature = FBase64::Encode(HmacResult);
	FString URLString = FPlatformHttp::UrlEncode(Signature);
	return URLString;
}
FString UInWebSocketSession::NowTimeString()
{
	FString Timestamp = FString::FromInt(FDateTime::UtcNow().ToUnixTimestamp());
	return Timestamp;
}
void UInWebSocketSession::SendAudioFile(const FString& FilePath)
{
	FString StoreDir = FPaths::ProjectSavedDir() / FilePath;
	TUniquePtr<FArchive> FileReader = TUniquePtr<FArchive>(IFileManager::Get().CreateFileReader(*StoreDir));
	if (!FileReader)
	{
		UE_LOG(LogTemp, Error, TEXT("Failed to open audio file: %s"), *StoreDir);
		return;
	}
	const int32 ChunkSize = 1280;
	int32 FileSize = FileReader->TotalSize();
	TArray<uint8> Buffer;
	Buffer.SetNumUninitialized(ChunkSize);
	while (!FileReader->AtEnd())
	{
		if (FileSize < ChunkSize) {
			FileReader->Serialize(Buffer.GetData(), FileSize);
			FileSize = 0;
		}
		else {
			FileReader->Serialize(Buffer.GetData(), ChunkSize);
			FileSize = FileSize - ChunkSize;
		}
		{
			// 发送二进制音频数据
			m_NativeSocket->Send(Buffer.GetData(), Buffer.Num(), true);

			// UE5中的延迟处理
			FPlatformProcess::Sleep(0.04f); // 40ms延迟
		}
	}

	TArray<uint8> EndTagData;
	FString EndTag = TEXT("{\"end\": true}");
	FTCHARToUTF8 Convert(*EndTag);
	EndTagData.Append((uint8*)Convert.Get(), Convert.Length());
	m_NativeSocket->Send(EndTagData.GetData(), EndTagData.Num(), false);
}
bool UInWebSocketSession::IsConnected()
{
	if (nullptr == m_NativeSocket)
	{
		return false;
	}
	return m_NativeSocket->IsConnected();

}
void UInWebSocketSession::OnConnected()
{
	UE_LOG(LogInWebSocketClientModule, Log, TEXT("UInWebSocketSession OnConnected Success url=%s"),*m_Url);

	OnConnectedEvent.Broadcast(this,"");
}
void UInWebSocketSession::OnError(const FString& Error)
{
	UE_LOG(LogInWebSocketClientModule, Error, TEXT("UInWebSocketSession OnError url=%s error=%s"), *m_Url, *Error);
	OnClosedEvent.Broadcast(this, "");
}
void UInWebSocketSession::OnClosed(int32 StatusCode, const FString& Reason, bool bWasClean)
{
	UE_LOG(LogInWebSocketClientModule, Log, TEXT("UInWebSocketSession OnClosed  url=%s StatusCode=%d Reason=%s bWasClean=%d"),
		*m_Url, StatusCode, *Reason, bWasClean);

	OnClosedEvent.Broadcast(this,"");
}
void UInWebSocketSession::OnMessage(const FString& MessageString)
{
	UE_LOG(LogInWebSocketClientModule, Log, TEXT("UInWebSocketSession OnMessage MessageString=%s"), *MessageString);

	OnMessageEvent.Broadcast(this,MessageString);
}
void UInWebSocketSession::OnRawMessage(const void* Data, SIZE_T  Size, SIZE_T  BytesRemaining)
{

}
