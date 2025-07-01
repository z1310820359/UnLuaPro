// Fill out your copyright notice in the Description page of Project Settings.

#pragma once

#include "CoreMinimal.h"
#include "GameFramework/Actor.h"
#include "UnLuaInterface.h"
#include "UnLuaEx.h"
#include "EnhancedInputComponent.h"
#include "UIInputActor.generated.h"

UCLASS()
class LUAFRAMEWORK_API AUIInputActor : public AActor, public IUnLuaInterface
{
	GENERATED_BODY()
	
public:	
	// Sets default values for this actor's properties
	AUIInputActor();

protected:
	// Called when the game starts or when spawned
	virtual void BeginPlay() override;

public:	
	// Called every frame
	virtual void Tick(float DeltaTime) override;

	virtual FString GetModuleName_Implementation() const override
	{
		return TEXT("Plugin.LuaFrameWork.Service.WorldService");
	}

	virtual void EnableInput(class APlayerController* PlayerController) override;

	UFUNCTION()
	void BindUIAction(FString ActionName, EInputEvent TriggerEvent, UObject* Object, (*UObject) Func);

	void ShowPrevEntry();
};
