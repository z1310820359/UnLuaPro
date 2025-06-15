// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "Subsystems/GameInstanceSubsystem.h"
#include "UnLuaInterface.h"
#include "UnLuaEx.h"
#include "LuaGameInstanceService.generated.h"

/**
 * 
 */
UCLASS()
class LUAFRAMEWORK_API ULuaGameInstanceService : public UGameInstanceSubsystem, public IUnLuaInterface
{
	GENERATED_BODY()
public:
	virtual FString GetModuleName_Implementation() const override
	{
		return TEXT("Plugin.LuaFrameWork.Service.GameInstanceService");
	}

	virtual bool ShouldCreateSubsystem(UObject* Outer) const override;
	virtual void Initialize(FSubsystemCollectionBase& Collection)override;
	virtual void Deinitialize()override;


	UFUNCTION(BlueprintImplementableEvent)
	void LuaInit();

	UFUNCTION(BlueprintImplementableEvent)
	void LuaDeinit();

	//首个参数为事件名String
	template <typename... T>
	void NotifyEventToLua(const char* EventName, T&&... Args)
	{
		FString EventNameStr(EventName);

		lua_State* L = UnLua::GetState();
		if (L)
		{
			const UnLua::FLuaRetValues LuaRetValues = UnLua::Call(L, "ReceiveNotifyFromC", TCHAR_TO_ANSI(*EventNameStr), Forward<T>(Args)...);
		}
	}

};
